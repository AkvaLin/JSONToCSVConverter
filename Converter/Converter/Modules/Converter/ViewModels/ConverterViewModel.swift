//
//  ConverterViewModel.swift
//  Converter
//
//  Created by Никита Пивоваров on 12.09.2023.
//

import Foundation

class ConverterViewModel: ObservableObject {
    
    @Published var isFileImporterShowing = false
    @Published var csvData: Data? = nil
    @Published var targetURL: URL? = nil
    @Published var isAdditionalConditionOn = false
    @Published var fileName = ""
    @Published var isSpinnerHidden: Bool = true
    @Published var text = ""
    
    public func selectFolder() {
        FolderPicker.selectFolder { [weak self] url in
            guard let strongSelf = self else { return }
            strongSelf.targetURL = url
        }
    }
    
    public func convert(url: URL) async {
        DispatchQueue.main.async {
            self.isSpinnerHidden = false
        }
        let gotAccess = url.startAccessingSecurityScopedResource()
        if !gotAccess { return }
        do {
            let data = try Data(contentsOf: url)
            
            try await Convertor.convertJSONDataToCSV(jsonData: data, isConditionActive: isAdditionalConditionOn) { [weak self] (csv, text) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.csvData = csv
                    strongSelf.isSpinnerHidden = true
                    strongSelf.text = text
                }
            }
        } catch let error {
            print(error)
        }
        url.stopAccessingSecurityScopedResource()
    }
    
    public func writeCSV() async {
        guard let url = targetURL, let csv = csvData else { return }
        
        do {
            try csv.write(to: url.appendingPathComponent("\(fileName).csv"))
        } catch let error {
            print(error)
        }
    }
}
