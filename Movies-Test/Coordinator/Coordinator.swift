//
//  Coordinator.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//
import UIKit
import Foundation

enum NavigationType {
    case present, push, window
}
protocol Coordinating: AnyObject{
    var navigationController: UINavigationController? {get set}
    var childCoordinators: [Coordinating] {get set}
    var vcFactory: ViewControllerFactory {get set}
    var coordinatorFactory: CoordinatorFactory {get set}
    func start(shouldAnimateTransition: Bool, navigationType: NavigationType)
}

protocol CoordinatedScreen{
    associatedtype Coordinator
    var coordinator: Coordinator {get set}
}
