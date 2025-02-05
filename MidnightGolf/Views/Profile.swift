//
//  Profile.swift
//  MidnightGolf
//
//  Created by Kasia Rivers on 2/4/25.
//

import SwiftUI
import PhotosUI

struct Profile: View {
    @State var imageSelection: PhotosPickerItem? = nil
    @State var uiImage: UIImage? = nil
    @State var interestField: String = ""
    
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            let smallTextSize = screenWidth * 0.03
            let largeTextSize = screenWidth * 0.05
            
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: screenHeight * 0.02) {
                        HStack(spacing: screenWidth * 0.05) {
                            PhotosPicker(
                                selection: $imageSelection,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                if let uiImage = uiImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                                        .foregroundStyle(.black)
                                }
                            }
                            .onChange(of: imageSelection) {
                                Task { @MainActor in
                                    if let data = try? await imageSelection?.loadTransferable(type: Data.self) {
                                        uiImage = UIImage(data: data)
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("NAME:")
                                    .font(.custom("NeueMontreal-Regular", size: smallTextSize))
                                Text("Hassan Alkhafaji")
                                    .font(.custom("NeueMontreal-Regular",size: largeTextSize))
                                    .padding(.bottom, 5)
                                
                                Text("GENDER:")
                                    .font(.custom("NeueMontreal-Regular",size: smallTextSize))
                                Text("Male")
                                    .font(.custom("NeueMontreal-Regular", size: largeTextSize))
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("HIGH SCHOOL:")
                                .font(.custom("NeueMontreal-Regular", size: smallTextSize))
                            Text("CASS TECH")
                                .font(.system(size: largeTextSize))
                                .padding(.bottom, 5)
                            
                            HStack(alignment: .center) {
                                Text("GPA:")
                                    .frame(alignment: .center)
                                    .font(.custom("NeueMontreal-Regular", size: smallTextSize))
                                    
                                Text("3.18")
                                    .font(.custom("NeueMontreal-Regular", size: largeTextSize))
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading) {
                                Text("INTEREST:")
                                    .font(.custom("NeueMontreal-Regular", size: largeTextSize))
                                    .padding(.bottom, 5)
                                
                                // Unsure if this should be an editable TextField or if the interests just get pulled from somewhere else.
                                // Can just uncomment the TextField if that's what we want to do.
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.  ")
                                    .font(.custom("NeueMontreal-Regular", size: smallTextSize))
                                    .frame(maxWidth: screenWidth * 0.6)
                                    .padding(5)
                                
//                                TextField("Enter Interest...", text: $interestField, axis: .vertical)
//                                    .font(.custom("NeueMontreal-Regular", size: smallTextSize))
//                                    .frame(maxWidth: screenWidth * 0.6)
//                                    .lineLimit(6...)
//                                    .padding(5)
                            }
                        }
                        .padding(.top, screenHeight * 0.03)
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, screenHeight * 0.05)
                }
                .safeAreaInset(edge: .top) {
                    Spacer().frame(height: screenHeight * 0.05)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Profile()
}
