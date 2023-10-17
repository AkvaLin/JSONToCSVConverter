//
//  GeneratiorViewModel.swift
//  Converter
//
//  Created by Никита Пивоваров on 12.09.2023.
//

import Foundation

class GeneratorViewModel: ObservableObject {
    @Published var text = ""
    @Published var targetURL: URL? = nil
    @Published var amountOfUsers: String = ""
    @Published var fileName: String = ""
    @Published var isSpinnerHidden: Bool = true
    
    public func generate() async {
        guard let url = targetURL, let amount = Int(amountOfUsers) else { return }
        
        DispatchQueue.main.async {
            self.isSpinnerHidden = false
        }
        
        let data = await Generator.generateData(numberOfBlocks: amount)
        let jsonEncdoer = JSONEncoder()
        jsonEncdoer.outputFormatting = .prettyPrinted
        do {
            let json = try jsonEncdoer.encode(data)
            try json.write(to: url.appendingPathComponent("\(fileName).json"))
            DispatchQueue.main.async {
                if data.count >= 7 {
                    self.text = self.formatText(model: Array(data[0..<7])) + "..."
                } else {
                    self.text = self.formatText(model: data)
                }
                self.isSpinnerHidden = true
            }
        } catch {
            
        }
    }
    
    public func selectFolder() {
        FolderPicker.selectFolder { [weak self] url in
            guard let strongSelf = self else { return }
            strongSelf.targetURL = url
        }
    }
    
    private func formatText(model: [UserModel]) -> String {
        var text = ""
        model.forEach { user in
            text += "ID: \(user.id)\n"
            text += "Name: \(user.name)\n"
            text += "Emails:\n"
            user.emails.forEach { email in
                text += "\(email)\n"
            }
            text += "Register date: \(user.registerDate)\n"
            text += "Last sign in date: \(user.lastSignInDate)\n"
            text += "Status: \(user.status ? "Confirmed" : "Not confirmed")\n"
            text += "Publications\n"
            user.publications.forEach { publication in
                text += "\tName: \(publication.name)\n"
                text += "\tDescription: \(publication.description)\n"
                text += "\tPages: \(publication.pages)\n"
                text += "\tCategory: \(publication.category)\n"
                text += "\tPublication date: \(publication.publicationDate)\n"
                text += "\tReviews:\n"
                publication.reviews.forEach { review in
                    text += "\t\tUser ID: \(review.id)\n"
                    text += "\t\tText: \(review.text)\n"
                }
            }
            text += "Date of birth: \(user.dateOfBirth)\n"
            text += "Sex: \(user.sex)\n"
            text += "\n"
        }
        return text
    }
}
