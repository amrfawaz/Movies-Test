//
//  ErrorModel.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import Foundation
struct ErrorModel: Codable {
    let error: String?
    let errorKey: Int?
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorKey = "error_key"
    }
}
