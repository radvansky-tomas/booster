//
//  SideViewController.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit
import Pages
import SideMenuController

class SideViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,PagesControllerDelegate,QuestionnaireDelegate,SideMenuControllerDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    var pages:PagesController?
    var data:[String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTableView.register(UINib.init(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        self.mainTableView.register(UINib(nibName: "SideHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SideHeader")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        self.mainTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mainTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return InvestorType.count
        }
        else
        {
            if let customSideMenuController:CustomSideMenuController = sideMenuController as? CustomSideMenuController
            {
                if customSideMenuController.currentQData != nil
                {
                    return 1
                }
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sideMenuCell:SideMenuCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        if indexPath.section == 0
        {
            sideMenuCell.customTextLabel.text = InvestorType.getType(index: indexPath.row).getDescription()
        }
        else
        {
            sideMenuCell.customTextLabel.text = NSLocalizedString("Global_Submit", comment: "Submit")
        }
        return sideMenuCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideHeader")
        let header = cell as! SideHeader
        
        if section == 0
        {
            header.customLabel.text = NSLocalizedString("SideMenu_InvestorTypes_Header", comment: "Investor Types")
            header.customButton.isUserInteractionEnabled = false
        }
        else
        {
            header.customLabel.text = NSLocalizedString("SideMenu_Questionnaire_Header", comment: "Questionnaire")
            header.customButton.isUserInteractionEnabled = true
            header.customButton.addTarget(forControlEvents: .touchUpInside, withClosure: { (control) in
                if let customSideMenuController:CustomSideMenuController = self.sideMenuController as? CustomSideMenuController
                {
                    if customSideMenuController.currentQData != nil
                    {
                        self.sideMenuController?.performSegue(withIdentifier: "QResultsSegue", sender: nil)
                        return
                    }
                }
                //Pager
                //Get Questions
                //Load plist
                var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
                
                var plistData:Array<AnyObject>?  //our data
                let plistPath:String? = Bundle.main.path(forResource: "RiskProfiler", ofType: "plist")! //the path of the data
                let plistXML = FileManager.default.contents(atPath: plistPath!)! //the data in XML format
                do{ //convert the data to a dictionary and handle errors.
                    plistData = try PropertyListSerialization.propertyList(from: plistXML,options: .mutableContainersAndLeaves,format: &format) as? Array<AnyObject>
                    if let data:Array<AnyObject> = plistData
                    {
                        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        var vcs:Array<UIViewController> = []
                        var index:Int = 1
                        for question in data
                        {
                            let parsedQuestion:QuestionnaireObject = QuestionnaireObject(plist: question as! [String : AnyObject])
                            let questionVC:QuestionnaireViewController = storyboard.instantiateViewController(withIdentifier: "QuestionnaireVC") as! QuestionnaireViewController
                            questionVC.currentQuestion = parsedQuestion
                            questionVC.title = String(format:NSLocalizedString("QuestionnaireVC_Navigation_Title", comment: "Question ?/?"),index,data.count)
                            questionVC.delegate = self
                            if index == 1
                            {
                                questionVC.isFirst = true
                            }
                            if index == data.count
                            {
                                questionVC.isLast = true
                            }
                            vcs.append(questionVC)
                            index = index + 1
                        }
                        
                        self.pages = PagesController(vcs)
                        self.pages!.pagesDelegate = self
                        self.pages!.enableSwipe = false
                        self.data = [:]
                        self.sideMenuController?.present(self.pages!, animated: true, completion: nil)
                    }
                }
                catch
                {
                    print("Error reading plist: \(error), format: \(format)")
                }
            })
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            sideMenuController?.performSegue(withIdentifier: "DetailFundSegue", sender: indexPath.row)
        }
        else
        {
            sideMenuController?.performSegue(withIdentifier: "SubmitSegue", sender: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, setViewController viewController: UIViewController, atPage page: Int) {
    }
    
    func questionnaireDismiss(controller: QuestionnaireViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func questionnaireNextPage(controller: QuestionnaireViewController, result: Int) {
        self.pages?.moveForward()
        self.data["Question\(controller.currentQuestion!.id ?? -1)"] = result
    }
    
    func questionnairePrevPage(controller: QuestionnaireViewController) {
        self.pages?.moveBack()
    }
    
    func questionnaireSubmit(controller: QuestionnaireViewController, result: Int) {
        self.data["Question\(controller.currentQuestion!.id ?? -1)"] = result
        controller.dismiss(animated: false) {
            //Show results
            self.sideMenuController?.performSegue(withIdentifier: "QResultsSegue", sender: self.data)
        }
    }
}

