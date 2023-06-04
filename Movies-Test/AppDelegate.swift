//
//  AppDelegate.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let vcFactory = ViewControllerFactory()
        let coordinatorFactory = CoordinatorFactory(vcFactory: vcFactory, window: window!)
        
        coordinatorFactory.makeMoviesListCoordinator().start(shouldAnimateTransition: true, navigationType: .window)
        setupNavigationBar()
        return true
    }

}



extension AppDelegate {
    private func setupNavigationBar() {
        if #available(iOS 13, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)]
            UINavigationBar.appearance().tintColor = .black
            navigationBarAppearance.backButtonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance

        }else{
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)]
            UINavigationBar.appearance().tintColor = .black
        }
    }
}
