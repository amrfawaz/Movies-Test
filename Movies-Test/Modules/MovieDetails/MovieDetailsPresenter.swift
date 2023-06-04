//
//  MovieDetailsPresenter.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import Foundation
protocol MovieDetailsPresenting {
    var viewDelegate: MovieDetailsViewDelegate? {get set}
    func getMovieDetails()
}

protocol MovieDetailsViewDelegate {
    func getMovieDetailsSuccessfully()
    func getMovieDetailsFaild(message: String)
}

class MovieDetailsPresenter: MovieDetailsPresenting {
    var coordinator: Coordinator
    typealias Coordinator = MovieDetailsCoordinating
    var viewDelegate: MovieDetailsViewDelegate?
    private var interactor: MovieDetailsInteracting
    private var movieId: String
    var movieDetails: MovieDetails?

    
    init(movieId: String, interactor: MovieDetailsInteracting, coordinator: Coordinator) {
        self.movieId = movieId
        self.interactor = interactor
        self.coordinator = coordinator
        self.interactor.presenterDelegate = self
    }

    func getMovieDetails() {
        interactor.getMovieDetails(movieId: movieId)
    }
}

extension MovieDetailsPresenter: MovieDetailsPresenterDelegate {
    func getMovieDetailsSuccessfully(movieDetails: MovieDetails) {
        self.movieDetails = movieDetails
        viewDelegate?.getMovieDetailsSuccessfully()
    }
    
    func getMovieDetailsFaild() {
        viewDelegate?.getMovieDetailsFaild(message: "Something went wrong")
    }
}
