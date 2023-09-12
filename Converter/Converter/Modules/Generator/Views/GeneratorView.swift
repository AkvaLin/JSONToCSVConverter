//
//  ContentView.swift
//  Converter
//
//  Created by Никита Пивоваров on 11.09.2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct GeneratorView: View {
    
    @StateObject private var viewModel = GeneratorViewModel()
    
    var body: some View {
        
        ZStack {
            HStack {
                VStack {
                    Text("Generate JSON with random data")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Select export path for new JSON:")
                    
                    Button("Choose Folder") {
                        viewModel.selectFolder()
                    }
                    .padding(.bottom)
                    
                    Text("Введите кол-во пользователей: ")
                    TextField("123", text: $viewModel.amountOfUsers)
                        .padding(.bottom)
                    
                    Text("Введите название нового файла: ")
                    TextField("MyNewJSON", text: $viewModel.fileName)
                        .padding(.bottom)
                    
                    if let _ = viewModel.targetURL,
                       let _ = Int(viewModel.amountOfUsers),
                       !viewModel.fileName.isEmpty {
                        Button {
                            Task {
                                await viewModel.generate()
                            }
                        } label: {
                            Text("Generate")
                        }
                        .padding(.bottom)
                    }
                }
                if !viewModel.text.isEmpty {
                    TextEditor(text: $viewModel.text)
                }
            }
            .textFieldStyle(.roundedBorder)
            
            if !viewModel.isSpinnerHidden {
                ProgressView()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorView()
    }
}
