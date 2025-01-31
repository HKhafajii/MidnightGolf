//
//  Email.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/27/24.
//

import Foundation
import MessageUI

class MailManager: NSObject, MFMailComposeViewControllerDelegate, ObservableObject {
    
    
//    ------- FUNCTIONS --------
    
    func sendEmail(subject: String, body: String, to: String) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannont send mail")
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([to])
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(body, isHTML: false)
        MailManager.getRootViewController()?.present(mailComposeVC, animated: true, completion: nil)
    } // End of sendEmail Function
    
    static func getRootViewController() -> UIViewController? {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        
        guard let firstWindow = firstScene.windows.first else { return nil }
        
        let viewController = firstWindow.rootViewController
        return viewController
    } // End of getRooatViewController Function
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case .sent:
            print("Email has been sent!")
            break
        case .cancelled:
            print("Email has been cancelled!")
            break
        case .failed:
            print("Email has failed to send!")
            break
        default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    } // End of mailComposeController Function
    
}

