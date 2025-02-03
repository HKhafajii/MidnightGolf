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
            
            ZStack {
                Image("background")
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
                                    .font(.system(size: screenWidth * 0.02))
                                Text("Hassan Alkhafaji")
                                    .font(.system(size: screenWidth * 0.04))
                                    .padding(.bottom, 5)
                                
                                Text("GENDER:")
                                    .font(.system(size: screenWidth * 0.02))
                                Text("Male")
                                    .font(.system(size: screenWidth * 0.04))
                            }
                            .padding(.leading)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("HIGH SCHOOL:")
                                .font(.system(size: screenWidth * 0.025))
                            Text("CASS TECH")
                                .font(.system(size: screenWidth * 0.04))
                                .padding(.bottom, 5)
                            
                            HStack(alignment: .center) {
                                Text("GPA:")
                                    .font(.system(size: screenWidth * 0.025))
                                Text("3.18")
                                    .font(.system(size: screenWidth * 0.035))
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading) {
                                Text("INTEREST:")
                                    .font(.system(size: screenWidth * 0.035))
                                    .padding(.bottom, 5)
                                TextField("Enter Interest...", text: $interestField, axis: .vertical)
                                    .frame(maxWidth: screenWidth * 0.6)
                                    .lineLimit(3...)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(5)
                            }
                        }
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
    }
}

#Preview {
    Profile()
}
