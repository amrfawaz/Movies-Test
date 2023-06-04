//
//  MoviesListCoordinator.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import Foundation
import UIKit

protocol MoviesListCoordinating {
    func goToMovieDetails(movieId: String)
}
class MoviesListCoordinator: RootCoordinator, MoviesListCoordinating {
        
    override func start(shouldAnimateTransition: Bool, navigationType: NavigationType) {
        navigationController = UINavigationController(rootViewController: vcFactory.makeMoviesListVC(coordinator: self))
        window.rootViewController = navigationController
    }
    
    func goToMovieDetails(movieId: String) {
        guard let navigationController = navigationController else { return }
        coordinatorFactory.makeMovieDetailsCoordinator(movieId: movieId, navigationController: navigationController).start(shouldAnimateTransition: true, navigationType: .push)
    }
}

