import UIKit
import MessageUI
import CoreImage.CIFilterBuiltins

class MailManager: NSObject, MFMailComposeViewControllerDelegate, ObservableObject {
    
    func sendEmail(students: [Student]) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send mail. Ensure Mail app is set up.")
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["alkhafajihassan@gmail.com"])
        mailComposeVC.setSubject("Student QR Codes")
        
        
        var emailBody = "<h2>Student List</h2><ul>"
        
        for student in students {
            emailBody += "<li><b>Name:</b> \(student.first) \(student.last) <br></li>"
            
            
            if let qrImage = student.qrCodeImage(),
               let imageData = qrImage.pngData() {
                
                
                mailComposeVC.addAttachmentData(imageData, mimeType: "image/png", fileName: "\(student.first)_\(student.last)_QRCode.png")
            } else {
                print("Failed to get QR image for:", student.first, student.last)
            }
        }
        
        emailBody += "</ul>"
        
        mailComposeVC.setMessageBody(emailBody, isHTML: true) // Use HTML formatting
        MailManager.getRootViewController()?.present(mailComposeVC, animated: true, completion: nil)
    }
    
    
    static func getRootViewController() -> UIViewController? {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        guard let firstWindow = firstScene.windows.first else { return nil }
        return firstWindow.rootViewController
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("Email has been sent successfully!")
        case .cancelled:
            print("Email was cancelled by the user.")
        case .failed:
            print("Email failed to send.")
        default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
