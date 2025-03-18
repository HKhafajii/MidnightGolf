////
////  ContentView.swift
////  HWSQRCode
////
////  Created by Hassan Alkhafaji on 1/16/25.
////
//
//import SwiftUI
//import CodeScanner
//
//struct ScannerView: View {
//    
//    enum FilterType {
//        case none, contacted, uncontacted
//    }
//    
//    let filter: FilterType = .none
//    @State private var isShowingScanner = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                
//                Text("Prospect Name")
//                
//                Text("Prospect address")
//                
//                
//                
//                
//            } // End of VStack
//            .padding()
//            .navigationTitle("Everyone")
//            .toolbar {
//                Button("Scan", systemImage: "qrcode.viewfinder") {
//                    isShowingScanner = true
//                }
//            }
//            .sheet(isPresented: $isShowingScanner) {
//                CodeScannerView(codeTypes: [.qr], simulatedData: "Hassan alkhafaji\nalkhafajihassan@gmail.com", completion: handleScan)
//            }
//        }
//    }
//    func handleScan(result: Result<ScanResult, ScanError>) {
//        
//        isShowingScanner = false
//        
//        
//        switch result {
//        case .success(let result):
//            let details = result.string.components(separatedBy: "\n")
//            guard details.count == 2 else { return }
//            
////            Make new person clas of information from code
////            Insert new person to the model
//            
//        case .failure(let error):
//            print("scanning failed: \(error.localizedDescription)")
//        }    }
//}
//
//#Preview {
//    ScannerView()
//}
