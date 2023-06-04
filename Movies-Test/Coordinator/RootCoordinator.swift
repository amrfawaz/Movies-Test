//
//  RootCoordinator.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import UIKit

protocol RootCoordinating: Coordinating, UINavigationControllerDelegate{
    var window: UIWindow {get set}
}

class RootCoordinator: NSObject, RootCoordinating{
    var window: UIWindow
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinating]()
    var coordinatorFactory: CoordinatorFactory
    var vcFactory: ViewControllerFactory
    
    init(window: UIWindow, viewFactory: ViewControllerFactory, coordinatorFactory: CoordinatorFactory) {
        self.coordinatorFactory = coordinatorFactory
        self.vcFactory = viewFactory
        self.window = window
    }
    
    func start(shouldAnimateTransition: Bool, navigationType: NavigationType) {}
}

extension RootCoordinator: UINavigationControllerDelegate{
    func childDidFinish(_ child: Coordinating?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        if let poppedCoordinator = fromViewController as? Coordinating {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(poppedCoordinator)
        }
    }
}
