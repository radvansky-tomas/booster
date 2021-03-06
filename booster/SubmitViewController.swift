//
//  SubmitViewController.swift
//  booster
//
//  Created by Tomas Radvansky on 11/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SubmitViewController: UIViewController,MFMailComposeViewControllerDelegate {
    var data:[String:Int]?
    
    @IBOutlet weak var nameTextfield: ALLocalizableTextField!
    
    @IBOutlet weak var phoneTextField: ALLocalizableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["me@example.com"])
        mailComposerVC.setSubject(String(format: NSLocalizedString("SubmitVC_Email_Subject", comment: "Subject"), nameTextfield.text.safeValue))
        if let dataU:[String:Int] = self.data
        {
            mailComposerVC.setMessageBody(String(format: NSLocalizedString("SubmitVC_Email_Message", comment: "Subject"), nameTextfield.text.safeValue,phoneTextField.text.safeValue,dataU.description), isHTML: false)
        }
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
