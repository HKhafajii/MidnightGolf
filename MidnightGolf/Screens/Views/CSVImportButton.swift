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
            
        } label: {
            Label("Import CSV", systemImage: "square.and.arrow.down")
        }
        .fileImporter(isPresented: $isPresented, allowedContentTypes: [UTType.commaSeparatedText]) { result in
            viewModel.csvMnager.handleFileImport(for: result)
        }
    }
}

#Preview {
    CSVImportButton()
        .environmentObject(ViewModel())
}
