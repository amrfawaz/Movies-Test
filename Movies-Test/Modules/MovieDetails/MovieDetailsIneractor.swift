//
//  MovieDetailsIneractor.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import Foundation
protocol MovieDetailsInteracting {
    var presenterDelegate: MovieDetailsPresenterDelegate? {set get}
    func getMovieDetails(movieId: String)
}
protocol MovieDetailsPresenterDelegate {
    func getMovieDetailsSuccessfully(movieDetails: MovieDetails)
    func getMovieDetailsFaild()
}
class MovieDetailsInteractor: MovieDetailsInteracting {
    
    var presenterDelegate: MovieDetailsPresenterDelegate?
    private let provider: MovieDetailsProvider
    
    
    init(provider: MovieDetailsProvider) {
        self.provider = provider
    }

    func getMovieDetails(movieId: String) {
        provider.getMovieDetails(id: movieId, ofType: MovieDetails.self) { [weak self] movieDetails in
            guard let movie = movieDetails else {
                self?.presenterDelegate?.getMovieDetailsFaild()
                return
            }
            self?.presenterDelegate?.getMovieDetailsSuccessfully(movieDetails: movie)
        }
    }
}
