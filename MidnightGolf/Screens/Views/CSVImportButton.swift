//
//  CSVImportButton.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 4/25/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct CSVImportButton: View {
    
    @State private var isPresented: Bool = false
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            Label("Import CSV", systemImage: "square.and.arrow.down")
        }
        .fileImporter(isPresented: $isPresented,
                      allowedContentTypes: [.commaSeparatedText]) { result in
            switch result {
            case .success(let url):
       
                Task {
                    await viewModel.importStudents(from: url)
                }
                print("got url:", url)

            case .failure(let error):
                print("File importer error:", error)
            }
        }
    }
}

#Preview {
    CSVImportButton()
        .environmentObject(ViewModel())
}
