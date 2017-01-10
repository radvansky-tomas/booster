//
//  QuestionnaireViewController.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit

protocol QuestionnaireDelegate {
    func questionnaireDismiss(controller:QuestionnaireViewController)
    func questionnaireNextPage(controller:QuestionnaireViewController, result:Int)
    func questionnaireSubmit(controller:QuestionnaireViewController, result:Int)
    func questionnairePrevPage(controller:QuestionnaireViewController)
}

class QuestionnaireViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var mainTableView: UITableView!
    var currentQuestion:QuestionnaireObject?
    var isLast:Bool = false
    var isFirst:Bool = false
    var delegate:QuestionnaireDelegate?
    var selected:Int = -1
    
    @IBOutlet weak var customNavTitle: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navigation
        customNavTitle.title = self.title
        if isFirst
        {
            customNavTitle.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelQuestions))
        }
        else
        {
           customNavTitle.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(prevQuestion))
        }
        
        if isLast
        {
            customNavTitle.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submit))
        }
        else
        {
          customNavTitle.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextQuestion))
        }
        
        self.mainTableView.register(UINib.init(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        self.mainTableView.register(UINib(nibName: "QuestionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "QuestionHeader")
        self.mainTableView.rowHeight = UITableViewAutomaticDimension
        self.mainTableView.estimatedRowHeight = 140
        self.mainTableView.reloadData()
    }
    
    func cancelQuestions()
    {
        delegate?.questionnaireDismiss(controller: self)
    }
    
    func prevQuestion()
    {
        delegate?.questionnairePrevPage(controller: self)
    }
    
    func nextQuestion()
    {
        if selected != -1
        {
            if let data:Array<Answer> = self.currentQuestion?.answers
            {
                delegate?.questionnaireNextPage(controller: self, result: data[selected].value ?? 0)
            }
        }
    }
    
    func submit()
    {
        if selected != -1
        {
            if let data:Array<Answer> = self.currentQuestion?.answers
            {
                delegate?.questionnaireSubmit(controller: self, result: data[selected].value ?? 0)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data:Array<Answer> = self.currentQuestion?.answers
        {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionCell:QuestionCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        questionCell.customTextLabel.text = self.currentQuestion?.answers?[indexPath.row].text
        if indexPath.row == self.selected
        {
           questionCell.imageView?.image = UIImage(icon: .FACheckSquare, size: CGSize.init(width: 16.0, height: 16.0), textColor: DefaultTheme.Color(color: .primaryColorDark), backgroundColor: UIColor.clear)
        }
        else
        {
        questionCell.imageView?.image = UIImage(icon: .FASquareO, size: CGSize.init(width: 16.0, height: 16.0), textColor: DefaultTheme.Color(color: .primaryColorDark), backgroundColor: UIColor.clear)
        }
        return questionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = indexPath.row
        tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QuestionHeader")
        let header = cell as! QuestionHeader
        
        if let questionString:String = self.currentQuestion?.question
        {
            header.customLabel.text = questionString
        }
        else
        {
            header.customLabel.text = "Unknown question"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let questionString:String = self.currentQuestion?.question
        {
           return questionString.heightWithConstrainedWidth(width: tableView.frame.size.width - 40.0, font: UIFont.systemFont(ofSize: 20.0))
        }
        else
        {
            return 44.0
        }
    }
}
