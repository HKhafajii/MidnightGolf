import UIKit
import SwiftUI
import MessageUI
import CoreImage.CIFilterBuiltins

class MailManager: NSObject, MFMailComposeViewControllerDelegate, ObservableObject {
    
    func sendEmail(students: [Student]) {
        print("📤 sendEmail called, students =", students.count)
         print("📮 canSendMail =", MFMailComposeViewController.canSendMail())

         guard MFMailComposeViewController.canSendMail() else {
             print("❌ Device can’t send mail - aborting.")
             return
         }

        // 2. Configure the composer
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["alkhafajihassan@gmail.com"])
        composer.setSubject("Student QR Codes")

        var body = "<h2>Student List</h2><ul>"
        for s in students {
            body += "<li><b>Name:</b> \(s.first) \(s.last)</li>"

            if let img = s.qrCodeImage(),
               let data = img.pngData() {
                composer.addAttachmentData(
                    data,
                    mimeType: "image/png",
                    fileName: "\(s.first)_\(s.last)_QRCode.png"
                )
            }
        }
        body += "</ul>"
        composer.setMessageBody(body, isHTML: true)

        // 3. Present on the main thread from the key-window’s root VC
        DispatchQueue.main.async {
            print("🖥 presenting composer on main thread")
            guard
                let windowScene = UIApplication.shared.connectedScenes
                                  .first(where: { $0.activationState == .foregroundActive })
                                  as? UIWindowScene,
                let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                let rootVC = window.rootViewController
            else {
                print("❌ No root view controller found.")
                return
            }

            rootVC.present(composer, animated: true)
        }
    }
    
    
    static func getRootViewController() -> UIViewController? {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        guard let firstWindow = firstScene.windows.first else { return nil }
        return firstWindow.rootViewController
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {

        print("🛫 mail result =", result.rawValue, error ?? "nil")   

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


struct MailComposeView: UIViewControllerRepresentable {

    let students: [Student]
    var onFinish: () -> Void = {}        // NEW callback
    @Environment(\.dismiss) private var dismiss
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["alkhafajihassan@gmail.com"])
        vc.setSubject("Student QR Codes")

        var body = "<h2>Student List</h2><ul>"
        for s in students {
            body += "<li><b>Name:</b> \(s.first) \(s.last)</li>"
            if let img = s.qrCodeImage(), let data = img.pngData() {
                vc.addAttachmentData(data,
                                     mimeType: "image/png",
                                     fileName: "\(s.first)_\(s.last)_QRCode.png")
            }
        }
        body += "</ul>"
        vc.setMessageBody(body, isHTML: true)
        return vc
    }

    func updateUIViewController(_ vc: MFMailComposeViewController, context: Context) {}


    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
        class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
            let parent: MailComposeView
            init(_ parent: MailComposeView) { self.parent = parent }

            func mailComposeController(_ controller: MFMailComposeViewController,
                                       didFinishWith result: MFMailComposeResult,
                                       error: Error?) {
                print("🛫 mailCompose result =", result.rawValue, error ?? "nil") 
                controller.dismiss(animated: true) {
                    self.parent.onFinish()   // notify SwiftUI
                    self.parent.dismiss()    // close the sheet
                }
            }
        }
}
