//
//  QuestionnaireResultsViewController.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit
import GaugeKit

class QuestionnaireResultsViewController: UIViewController {
    
    @IBOutlet weak var gaugeView: Gauge!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var showBtn: ALLocalizableButton!
    
    var result:[String:Int]?
    var score:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Results"
        if let resultUnwrapped:[String:Int] = self.result
        {
            for entry in resultUnwrapped.values
            {
                score = score + entry
            }
            gaugeView.animateRate(1.5, newValue: CGFloat(score), completion: { (completed) in
                self.resultLabel.text = "You are \(InvestorType.getTypeByScore(score: self.score).getDescription().lowercased()) investor!"
                self.scoreLabel.text = "\(self.score)"
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.scoreLabel.alpha = 1.0
                    self.resultLabel.alpha = 1.0
                    self.showBtn.alpha = 1.0
                })
            })
            
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showBtnClicked(_ sender: Any) {
        if score > 0
        {
            let investor = InvestorType.getTypeByScore(score: self.score)
            sideMenuController?.performSegue(withIdentifier: "DetailFundSegue", sender: investor.rawValue)
        }
    }
}
