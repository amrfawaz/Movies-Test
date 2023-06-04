//
//  Constants.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import Foundation


enum Endpoints {
    case moviesList
    case movieDetails(String)
    var path: String {
        switch self {
        case .moviesList:
            return "/discover/movie"
        case .movieDetails(let id):
            return "/movie/\(id)"
        }
    }
}
