//
//  MoviesListInteractor.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import Foundation
protocol MoviesListInteracting {
    var presenterDelegate: MoviesListPresenterDelegate? {set get}
    func getMoviesList()
}
protocol MoviesListPresenterDelegate {
    func getMoviesListSuccessfully(movies: [Movie])
    func getMoviesListFaild()
}
class MoviesListInteractor: MoviesListInteracting {
    
    var presenterDelegate: MoviesListPresenterDelegate?
    private let provider: MoviesListProvider
    
    init(provider: MoviesListProvider) {
        self.provider = provider
    }

    func getMoviesList() {
        provider.getMoviesList(ofType: MoviesListResponse.self) { [weak self] response in
            guard let movies = response?.movies else {
                self?.presenterDelegate?.getMoviesListFaild()
                return
            }
            self?.presenterDelegate?.getMoviesListSuccessfully(movies: movies)
        }
    }
}
