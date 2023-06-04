//
//  MoviesListPresenter.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import Foundation

protocol MoviesListPresenting {
    var viewDelegate: MoviesListViewDelegate? {get set}
    func getMoviesList()
}
protocol MoviesListViewDelegate {
    func getMoviesListSuccessfully()
    func getMoviesListFaild(message: String)
}
class MoviesListPresenter: MoviesListPresenting {
    
    var coordinator: Coordinator
    typealias Coordinator = MoviesListCoordinating
    var viewDelegate: MoviesListViewDelegate?
    private var interactor: MoviesListInteracting
    var movies: [Movie]?

    
    init(interactor: MoviesListInteracting, coordinator: Coordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
        self.interactor.presenterDelegate = self
    }

    func getMoviesList() {
        interactor.getMoviesList()
    }
    
    func numberOfMovies() -> Int {
        movies?.count ?? 0
    }
    
    func didSelectMovie(movieId: String) {
        coordinator.goToMovieDetails(movieId: movieId)
    }
}

extension MoviesListPresenter: MoviesListPresenterDelegate {
    func getMoviesListSuccessfully(movies: [Movie]) {
        self.movies = movies
        viewDelegate?.getMoviesListSuccessfully()
    }
    
    func getMoviesListFaild() {
        viewDelegate?.getMoviesListFaild(message: "Something went wrong")
    }
}
