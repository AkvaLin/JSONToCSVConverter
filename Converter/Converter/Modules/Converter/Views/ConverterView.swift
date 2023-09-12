//
//  ConvertorView.swift
//  Converter
//
//  Created by Никита Пивоваров on 11.09.2023.
//

import SwiftUI

struct ConverterView: View {
    
    @StateObject private var viewModel = ConverterViewModel()
    
    var body: some View {
        
        ZStack {
            HStack {
                VStack {
                    Text("Convert JSON to CSV")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Choose JSON file that will be transformed to CSV")
                    Button {
                        viewModel.isFileImporterShowing.toggle()
                    } label: {
                        Text("Choose file")
                    }.fileImporter(isPresented: $viewModel.isFileImporterShowing, allowedContentTypes: [.json], allowsMultipleSelection: false) { result in
                        switch result {
                        case .success(let success):
                            Task {
                                await viewModel.convert(url: success[0])
                            }
                        case .failure:
                            break
                        }
                    }
                    .padding(.bottom)
                    
                    Text("Check this before choosing a file!")
                        .font(.headline)
                    Toggle("Activate additional condition\nRemove unconfirmed records", isOn: $viewModel.isAdditionalConditionOn)
                        .toggleStyle(.checkbox)
                        .padding(.bottom)
                    
                    if let _ = viewModel.csvData {
                        Text("Select export path:")
                        Button("Choose Folder") {
                            viewModel.selectFolder()
                        }
                        Text("Select export path for new CSV:")
                        TextField("MyNewCSV", text: $viewModel.fileName)
                    }
                    
                    if let _ = viewModel.csvData,
                       let _ = viewModel.targetURL,
                       !viewModel.fileName.isEmpty {
                        Button {
                            Task {
                                await viewModel.writeCSV()
                            }
                        } label: {
                            Text("Export")
                        }
                        .padding(.top)
                    }
                }
                .textFieldStyle(.roundedBorder)
                
                if !viewModel.text.isEmpty {
                    TextEditor(text: $viewModel.text)
                }
            }
            
            if !viewModel.isSpinnerHidden {
                ProgressView()
            }
        }
        .padding()
    }
}

struct ConvertorView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView()
    }
}
