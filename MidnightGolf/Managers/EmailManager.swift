import UIKit
import MessageUI
import CoreImage.CIFilterBuiltins

class MailManager: NSObject, MFMailComposeViewControllerDelegate, ObservableObject {
    
    func generateQRCode(from string: String) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            return UIImage(ciImage: transformedImage)
        }
        
        return nil
    }
    
    func sendEmail(students: [Student]) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send mail. Ensure Mail app is set up.")
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["admin@yourorganization.com"])
        mailComposeVC.setSubject("Student QR Codes")
        
        var emailBody = "<h2>Student List</h2><ul>"
        
        for student in students {
            emailBody += "<li><b>Name:</b> \(student.first) \(student.last) <br></li>"
            
            if let qrImage = generateQRCode(from: student.qrCode),
               let imageData = qrImage.pngData() {
                
                mailComposeVC.addAttachmentData(imageData, mimeType: "image/png", fileName: "\(student.first) \(student.last)_QRCode.png")
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
            print("Email has been sent!")
        case .cancelled:
            print("Email was cancelled.")
        case .failed:
            print("Email failed to send.")
        default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
