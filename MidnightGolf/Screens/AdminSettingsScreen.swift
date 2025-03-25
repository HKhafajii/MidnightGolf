//
//  AdminSettingsScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 3/10/25.
//


import SwiftUI

enum AdminSettings: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    case changeLateThreshold = "Change Late Threshold"
    case somethingElse = "Something Else"
}

struct AdminSettingsScreen: View {
    
    @State private var selectedSetting: AdminSettings? = .changeLateThreshold
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView {
            List(AdminSettings.allCases, selection: $selectedSetting) { setting in
                NavigationLink(value: setting) {
                    Text(setting.rawValue)
                        .foregroundStyle(Color("MGPnavy"))
                        .font(.headline)
                }
            }
            .navigationTitle("Admin Settings")
            
        } detail: {
            DetailView(selectedSetting: selectedSetting)
        }
        .tint(Color("MGPnavy"))
    }
}

struct DetailView: View {
    let selectedSetting: AdminSettings?
    
    var body: some View {
        Group {
            if let setting = selectedSetting {
                switch setting {
                case .changeLateThreshold:
                    LateThresholdChanges()
                case .somethingElse:
                    SomethingElseView()
                }
            } else {
                Text("Select a setting")
                    .foregroundStyle(Color("MGPnavy"))
            }
        }
        .animation(.easeInOut, value: selectedSetting)
    }
}

#Preview {
    AdminSettingsScreen()
        .environmentObject(ViewModel())
}

struct SomethingElseView: View {
    var body: some View {
        Text("Hello, World!")
    }
}


struct LateThresholdChanges: View {
    @State var intValue: Int = 0
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                
                TitleComponent(title: "Change Late Threshold")
                
                Text("Enter an hour and a minute to change when a student is considered late")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                NumberFieldComponent(title: "Threshold Hour", description: "Type an hour", intValue: intValue)
                NumberFieldComponent(title: "Threshold Minute", description: "Type an hour", intValue: intValue)
                
                
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("MGPnavy"))
                            .frame(maxWidth: CheckInScreen.deviceWidth / 2.5,
                                   maxHeight: CheckInScreen.deviceHeight * 0.05)
                            .shadow(radius: 8, x: 0, y: 0)
                        
                        Text("Save Changes")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: CheckInScreen.deviceWidth / 2.5)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}


