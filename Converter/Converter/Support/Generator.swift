//
//  Generator.swift
//  Converter
//
//  Created by Никита Пивоваров on 11.09.2023.
//

import Foundation

enum Generator {
    static func generateData(numberOfBlocks: Int) async -> [UserModel]  {
        var users = [UserModel]()
        for _ in 0..<numberOfBlocks {
            let id = UUID()
            let name = randomString(minLength: 3, maxLength: 12)
            var emails = [String]()
            for _ in 0...Int.random(in: 0...5) {
                emails.append(randomString(minLength: 1, maxLength: 30)+"@"+randomString(minLength: 3, maxLength: 7)+"."+randomString(minLength: 2, maxLength: 3))
            }
            
            var publications = [PublicationModel]()
            
            for _ in 0...randomInt(1, 10) {
                var reviews = [ReviewModel]()
                
                for _ in 0...randomInt(0, 10) {
                    reviews.append(ReviewModel(id: UUID(),
                                               text: randomString(minLength: 50, maxLength: 1000)))
                }
                
                let publication = PublicationModel(name: randomString(minLength: 5, maxLength: 100),
                                                    description: randomString(minLength: 250, maxLength: 1000),
                                                    pages: randomInt(),
                                                    category: randomString(minLength: 5, maxLength: 20),
                                                    publicationDate: randomDate(),
                                                    reviews: reviews)
                
                publications.append(publication)
            }
            
            let userModel = UserModel(id: id,
                                      name: name,
                                      emails: emails,
                                      registerDate: randomDate(),
                                      lastSignInDate: randomDate(),
                                      status: randomBool(),
                                      publications: publications,
                                      dateOfBirth: randomDate(),
                                      sex: randomGender())
            
            users.append(userModel)
        }
        return users
    }
    
    static func randomString(minLength: Int, maxLength: Int) -> String {
        let length = Int.random(in: minLength...maxLength)
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\n"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    static func randomDate() -> String {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return Date(timeIntervalSince1970: randomTime).formatted(date: .long, time: .complete)
    }
    static func randomInt(_ lower: Int = 0, _ upper: Int = 100) -> Int {
        return Int.random(in: lower...upper)
    }
    public static func randomBool() -> Bool {
        return randomInt() % 2 == 0
    }
    public static func randomGender() -> String {
        return randomBool() ? "Male" : "Female"
    }
}
