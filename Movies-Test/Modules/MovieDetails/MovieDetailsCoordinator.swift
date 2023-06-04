//
//  MovieDetailsCoordinator.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import Foundation
import UIKit

protocol MovieDetailsCoordinating {
}
class MovieDetailsCoordinator: MovieDetailsCoordinating, Coordinating {
    
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinating] = []
    var vcFactory: ViewControllerFactory
    var coordinatorFactory: CoordinatorFactory
    let movieId: String
    

    init(navigationController: UINavigationController, vcFactory: ViewControllerFactory, coordinatorFactory: CoordinatorFactory, movieId: String) {
        self.navigationController = navigationController
        self.vcFactory = vcFactory
        self.coordinatorFactory = coordinatorFactory
        self.movieId = movieId
    }
    func start(shouldAnimateTransition: Bool, navigationType: NavigationType) {
        navigationController?.pushViewController((vcFactory.makeMovieDetailsVC(movieId: movieId, coordinator: self)), animated: true)
    }
}

