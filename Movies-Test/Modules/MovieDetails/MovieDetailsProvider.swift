//
//  MovieDetailsProvider.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import Foundation

protocol MovieDetailsProviding {
    func getMovieDetails<T: Decodable>(id: String, ofType: T.Type ,completion: @escaping (T?)->())
}

class MovieDetailsProvider: MovieDetailsProviding {
    private let provider: Provider
    private let movieDetailsEndPoint = rootUrl + apiVersion
    init(provider: Provider) {
        self.provider = provider
    }
    
    func getMovieDetails<T>(id: String, ofType: T.Type, completion: @escaping (T?) -> ()) where T : Decodable {
        let headers = provider.buildHeaders(headerDictionary: [.accept: "application/json"])
        let params = apiKey
        provider.getRequest(url: movieDetailsEndPoint + Endpoints.movieDetails(id).path, T.self, ErrorModel.self, headers: headers, params: params, parameterEncoding: .urlEncodingDefault) { data, error  in
            completion(data)
        }
    }
}
