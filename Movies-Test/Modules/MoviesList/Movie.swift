//
//  Movie.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import Foundation

class MoviesListResponse: Codable {
    var page: Int?
    let totalResults: Int?
    let totalPages: Int?
    var movies: [Movie]?
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }

}

class Movie: Codable {
    let id: Int?
    let title: String?
    let releaseDate: String?
    let overview: String?
    let poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case overview
        case poster = "poster_path"
    }
}
