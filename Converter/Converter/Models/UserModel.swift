//
//  Model.swift
//  Converter
//
//  Created by Никита Пивоваров on 11.09.2023.
//

import Foundation

struct UserModel: Codable {
    let id: UUID
    let name: String
    let emails: [String]
    let registerDate: String
    let lastSignInDate: String
    let status: Bool
    let publications: [PublicationModel]
    let dateOfBirth: String
    let sex: String
}
