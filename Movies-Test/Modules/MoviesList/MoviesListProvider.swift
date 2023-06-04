//
//  MoviesListProvider.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import Foundation

protocol MoviesListProviding {
    func getMoviesList<T: Decodable>(ofType: T.Type ,completion: @escaping (T?)->())
}

class MoviesListProvider: MoviesListProviding {
    private let provider: Provider
    private let moviesEndPoint = rootUrl + apiVersion
    init(provider: Provider) {
        self.provider = provider
    }
    
    func getMoviesList<T>(ofType: T.Type, completion: @escaping (T?) -> ()) where T : Decodable {
        let headers = provider.buildHeaders(headerDictionary: [.accept: "application/json"])
        let params = apiKey
        provider.getRequest(url: moviesEndPoint + Endpoints.moviesList.path, T.self, ErrorModel.self, headers: headers, params: params, parameterEncoding: .urlEncodingDefault) { data, error  in
            completion(data)
        }
    }
}
