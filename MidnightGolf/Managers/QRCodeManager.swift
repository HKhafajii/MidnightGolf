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
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func convertImageToData(image: UIImage) -> Data? {
        return image.pngData()
    }
    
}
