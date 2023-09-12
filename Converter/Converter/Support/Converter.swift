//
//  Converter.swift
//  Converter
//
//  Created by Никита Пивоваров on 11.09.2023.
//

import Foundation
import TabularData

enum Convertor {
    static func convertJSONDataToCSV(jsonData: Data, isConditionActive: Bool, complition: @escaping (Data, String) -> Void) async throws {
        do {
            var jsonData = try JSONDecoder().decode([UserModel].self, from: jsonData)
            
            if isConditionActive {
                jsonData.removeAll { user in
                    user.status == false
                }
            }
            
            var csvDataFrame = DataFrame()
            
            var maxEmailAmount = 0
            var maxPublicationsAmount = 0
 
            jsonData.forEach { user in
                if user.emails.count > maxEmailAmount {
                    maxEmailAmount = user.emails.count
                }
                if user.publications.count > maxPublicationsAmount {
                    maxPublicationsAmount = user.publications.count
                }
            }
            
            var maxReviewsAmountForEachPublication = Array(repeating: 0, count: maxPublicationsAmount)
            
            jsonData.forEach { user in
                user.publications.enumerated().forEach { (index, publication) in
                    if maxReviewsAmountForEachPublication[index] < publication.reviews.count {
                        maxReviewsAmountForEachPublication[index] = publication.reviews.count
                    }
                }
            }
            
            var ids: [UUID] = []
            var names: [String] = []
            var emails: [[String]] = Array(repeating: [String](), count: maxEmailAmount)
            var registerDates: [String] = []
            var lastSignInDates: [String] = []
            var statuses: [Bool] = []
            var datesOfBirth: [String] = []
            var sexs: [String] = []
            var publicationNames: [[String]] = Array(repeating: [String](), count: maxPublicationsAmount)
            var publicationDescriptions: [[String]] = Array(repeating: [String](), count: maxPublicationsAmount)
            var publicationPages: [[Int]] = Array(repeating: [Int](), count: maxPublicationsAmount)
            var publicationCategory: [[String]] = Array(repeating: [String](), count: maxPublicationsAmount)
            var publicationDate: [[String]] = Array(repeating: [String](), count: maxPublicationsAmount)
            var reviewTexts: [[[String]]] = []
            var reviewIDs: [[[UUID?]]] = []
            
            for i in 0..<maxPublicationsAmount {
                var arrTexts = [[String]]()
                var arrIds = [[UUID?]]()
                for _ in 0...maxReviewsAmountForEachPublication[i] {
                    arrTexts.append([])
                    arrIds.append([])
                }
                reviewTexts.append(arrTexts)
                reviewIDs.append(arrIds)
            }
            
            jsonData.forEach { user in
                ids.append(user.id)
                names.append(user.name)
                registerDates.append(user.registerDate)
                lastSignInDates.append(user.lastSignInDate)
                statuses.append(user.status)
                datesOfBirth.append(user.dateOfBirth)
                sexs.append(user.sex)
                
                var userEmails = user.emails
                if userEmails.count < maxEmailAmount {
                    for _ in 0..<maxEmailAmount-userEmails.count {
                        userEmails.append("")
                    }
                }
                for i in 0..<maxEmailAmount {
                    emails[i].append(userEmails[i])
                }
                
                var userPublications = user.publications
                if userPublications.count < maxPublicationsAmount {
                    for _ in 0..<maxPublicationsAmount-userPublications.count {
                        userPublications.append(PublicationModel(name: "",
                                                                  description: "",
                                                                  pages: 0,
                                                                  category: "",
                                                                  publicationDate: "",
                                                                  reviews: []))
                    }
                }
                for i in 0..<maxPublicationsAmount {
                    publicationNames[i].append(userPublications[i].name)
                    publicationDescriptions[i].append(userPublications[i].description)
                    publicationPages[i].append(userPublications[i].pages)
                    publicationCategory[i].append(userPublications[i].category)
                    publicationDate[i].append(userPublications[i].publicationDate)
                }
                
                userPublications.enumerated().forEach { (index, publication) in
                    var userReviews = publication.reviews.map { $0.text }
                    var userIDs: [UUID?] = publication.reviews.map { $0.id }
                    if userReviews.count < maxReviewsAmountForEachPublication[index] {
                        for _ in 0..<maxReviewsAmountForEachPublication[index]-userReviews.count {
                            userReviews.append("")
                            userIDs.append(nil)
                        }
                    }
                    userReviews.enumerated().forEach { (reviewIndex, value) in
                        reviewTexts[index][reviewIndex].append(value)
                        reviewIDs[index][reviewIndex].append(userIDs[reviewIndex])
                    }
                }
            }
            
            csvDataFrame.append(column: Column(name: "id", contents: ids))
            csvDataFrame.append(column: Column(name: "name", contents: names))
            csvDataFrame.append(column: Column(name: "registerDate", contents: registerDates))
            csvDataFrame.append(column: Column(name: "lastSignInDate", contents: lastSignInDates))
            csvDataFrame.append(column: Column(name: "status", contents: statuses))
            csvDataFrame.append(column: Column(name: "dateOfBirth", contents: datesOfBirth))
            csvDataFrame.append(column: Column(name: "sex", contents: sexs))
            
            emails.enumerated().forEach { (id, email) in
                csvDataFrame.append(column: Column(name: "email \(id+1)", contents: email))
            }
            
            for i in 0..<maxPublicationsAmount {
                csvDataFrame.append(column: Column(name: "Publication \(i+1) name", contents: publicationNames[i]))
                csvDataFrame.append(column: Column(name: "Publication \(i+1) description", contents: publicationDescriptions[i]))
                csvDataFrame.append(column: Column(name: "Publication \(i+1) pages", contents: publicationPages[i]))
                csvDataFrame.append(column: Column(name: "Publication \(i+1) category", contents: publicationCategory[i]))
                csvDataFrame.append(column: Column(name: "Publication \(i+1) published date", contents: publicationDate[i]))
                for j in 0..<maxReviewsAmountForEachPublication[i] {
                    csvDataFrame.append(column: Column(name: "Publications \(i+1) review \(j+1) id", contents: reviewIDs[i][j]))
                    csvDataFrame.append(column: Column(name: "Publications \(i+1) review \(j+1) text", contents: reviewTexts[i][j]))
                }
            }
            
            let options = CSVWritingOptions(includesHeader: true,
                                            nilEncoding: "",
                                            trueEncoding: "true",
                                            falseEncoding: "false",
                                            newline: "\n",
                                            delimiter: ",")
            
            let csvData = try csvDataFrame.csvRepresentation(options: options)
            complition(csvData, csvDataFrame.description)
        } catch let error {
            throw error
        }
    }
}
