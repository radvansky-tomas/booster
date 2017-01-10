//
//  AboutViewController.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
     @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTableView.rowHeight = UITableViewAutomaticDimension
        self.mainTableView.estimatedRowHeight = 140
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let titleCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            titleCell.textLabel?.text = NSLocalizedString("AboutVC_Title_Label", comment: "We are booster")
            return titleCell
        }
        else
        {
             let textCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            textCell.contentView.backgroundColor = DefaultTheme.Color(color: .secondaryColor)
            textCell.textLabel?.text = NSLocalizedString("AboutVC_Title_Text", comment: "About us")
            textCell.textLabel?.backgroundColor = UIColor.clear
            return textCell
        }
    }
    
}
