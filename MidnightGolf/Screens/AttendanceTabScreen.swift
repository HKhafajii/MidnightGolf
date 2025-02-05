//
//  AttendanceTabScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/14/25.
//

import SwiftUI

struct AttendanceTabScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var selectedFilter = 0
    let filters = ["Daily", "Weekly", "Monthly"]
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            NavigationStack {
                ZStack {
                    Image("bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth, height: screenHeight)
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                Text("Attendance")
                                    .font(.custom("NeueMontreal-Bold", size: screenWidth * 0.06).bold())
                                    .foregroundColor(.black)
                                    .padding(.top, screenHeight * 0.05)
                                    .padding(.bottom)
                                    .padding(.leading, screenWidth * 0.07)
                                Spacer()
                            }
                        }
                        Spacer()
                        VStack {
                            CustomSegmentedPicker(selectedIndex: $selectedFilter, options: filters)
                                .font(.custom("NeueMontreal-Regular", size: screenWidth * 0.03))
                                .padding()
                            
                            Text("Selected: \(filters[selectedFilter])")
                                .font(.headline)
                                .padding()
                            
                            // Put data here
                            
                            ScrollView {
                                Group {
                                    if selectedFilter == 0 {
                                        Text("Daily")
                                    } else if selectedFilter == 1 {
                                        Text("Weekly")
                                    } else {
                                        Text("Monthly")
                                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.  ")
                                    }
                                }
                            }
                            .frame(maxWidth: screenWidth * 0.6)

                            HStack(spacing: screenWidth * 0.008) {
                                ForEach(filters.indices, id: \.self) { index in
                                    Circle()
                                        .frame(width: screenWidth * 0.01, height: screenHeight * 0.01)
                                        .foregroundColor(selectedFilter == index ? .black : .gray)
                                        .scaleEffect(selectedFilter == index ? 1.2 : 1.0) // Enlarged active dot
                                        .animation(.smooth, value: selectedFilter)
                                }
                            }
                            .padding(.top, screenHeight * 0.4)
                            .padding(.bottom)
                            Spacer()
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                Spacer().frame(height: screenHeight * 0.05)
            }
        }
        .ignoresSafeArea()
    }
}


struct CustomSegmentedPicker: View {
    @Binding var selectedIndex: Int
    let options: [String]
    
    var body: some View {
        HStack {
            ForEach(options.indices, id: \.self) { index in
                Text(options[index])
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                    .background(
                        ZStack {
                            if selectedIndex == index {
                                //Capsule()
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white)
                                    .matchedGeometryEffect(id: "selector", in: animation)
                            }
                        }
                    )
                    .foregroundColor(.black)
                    .onTapGesture {
                        withAnimation(.smooth) {
                            selectedIndex = index
                        }
                    }
            }
        }
        .padding(5)
        .background(Color(.systemGray4))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    @Namespace private var animation
}

#Preview {
    AttendanceTabScreen()
}
