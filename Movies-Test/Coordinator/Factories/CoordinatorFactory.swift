//
//  CoordinatorFactory.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import UIKit

class CoordinatorFactory {
    
    private let vcFactory: ViewControllerFactory
    private let window: UIWindow
    init(vcFactory: ViewControllerFactory, window: UIWindow){
        self.vcFactory = vcFactory
        self.window = window
    }
    func makeMoviesListCoordinator()-> Coordinating {
        MoviesListCoordinator(window: window, viewFactory: vcFactory, coordinatorFactory: self)
    }
    
    func makeMovieDetailsCoordinator(movieId: String, navigationController: UINavigationController) -> Coordinating {
        MovieDetailsCoordinator(navigationController: navigationController, vcFactory: vcFactory, coordinatorFactory: self, movieId: movieId)
    }
}

protocol ChefaaCoordinating {
}
