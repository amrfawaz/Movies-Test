//
//  MovieDetails.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import Foundation

struct MovieDetails: Codable {
    let id: Int
    let title, originalTitle, overview: String
    let posterPath: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
