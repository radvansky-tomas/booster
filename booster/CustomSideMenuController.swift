//
//  CustomSideMenuController.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit
import SideMenuController
import Font_Awesome_Swift

class CustomSideMenuController: SideMenuController {
    //Presence of this is causing submit button to show
    var currentQData:[String:Int]?
    
    required init?(coder aDecoder: NSCoder) {
        //Side menu design
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(icon: FAType.FABars, size: CGSize(width: 24.0, height: 24.0), textColor: UIColor.white, backgroundColor: UIColor.clear)
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelRight
        SideMenuController.preferences.drawing.sidePanelWidth = 240
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initial setup
        performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        performSegue(withIdentifier: "embedSideController", sender: nil)
        self.delegate = self.sideViewController as! SideViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailFundSegue"
        {
            let dest:FundDetailViewController = (segue.destination as! UINavigationController).viewControllers[0] as! FundDetailViewController
            dest.investorType = InvestorType(rawValue: sender as! Int)
        }
        else if segue.identifier == "QResultsSegue"
        {
            let dest:QuestionnaireResultsViewController = (segue.destination as! UINavigationController).viewControllers[0] as! QuestionnaireResultsViewController
            if sender != nil
            {
                self.currentQData = sender as? [String:Int]
            }
            dest.result = self.currentQData!
        }
        else if segue.identifier == "SubmitSegue"
        {
              let dest:SubmitViewController = (segue.destination as! UINavigationController).viewControllers[0] as! SubmitViewController
                dest.data = self.currentQData
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
