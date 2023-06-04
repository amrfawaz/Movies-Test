//
//  ViewControllerFactory.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import Foundation
import Kingfisher

class ViewControllerFactory {

    func makeMoviesListVC(coordinator: MoviesListCoordinating) -> MoviesListViewController {
        MoviesListViewController(presenter: MoviesListPresenter(interactor: MoviesListInteractor(provider: MoviesListProvider(provider: Provider())), coordinator: coordinator))
    }
    
    func makeMovieDetailsVC(movieId: String, coordinator: MovieDetailsCoordinating) -> MovieDetailsViewController {
        MovieDetailsViewController(presenter: MovieDetailsPresenter(movieId: movieId, interactor: MovieDetailsInteractor(provider: MovieDetailsProvider(provider: Provider())), coordinator: coordinator))
    }
}
