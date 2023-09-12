//
//  PublicationModel.swift
//  Converter
//
//  Created by Никита Пивоваров on 11.09.2023.
//

import Foundation

struct PublicationModel: Codable {
    let name: String
    let description: String
    let pages: Int
    let category: String
    let publicationDate: String
    let reviews: [ReviewModel]
}
