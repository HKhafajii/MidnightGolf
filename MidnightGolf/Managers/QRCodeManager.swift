//
//  QRCodeManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/14/25.
//

import Foundation
import CoreImage.CIFilterBuiltins
import SwiftUI

class QRCodeManager {
    
    //    ------ Variables ---------
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    
    //    ------ Functions ---------
    
    func generateQRCode(from string: String) -> UIImage? {
            guard !string.isEmpty else { return nil }
            
            filter.message = Data(string.utf8)
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
            
            return nil
        } // End of GenerateQRCode
    
    func convertImageToData(image: UIImage) -> Data? {
        return image.pngData()
    } // End of Converting image to data
    
    
} // End of QR code manager
