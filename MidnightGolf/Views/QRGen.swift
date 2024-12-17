//
//  SwiftUIView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/26/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRGen: View {
    
    @State private var name = ""
    @State private var emailAddress = ""
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack{
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title2)
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title2)
                
                NavigationLink {
                    Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } label: {
                    Text("Generate QR Code")
                }

                
            }
            .navigationTitle("Your code")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}

#Preview {
    QRGen()
}
