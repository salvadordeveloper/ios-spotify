//
//  SceneDelegate.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        if AuthManager.shared.isSignedIn {
            window?.rootViewController = Spotify()
        } else {
            let navVc = UINavigationController(rootViewController: WelcomeViewController())
            navVc.navigationBar.prefersLargeTitles = true
            navVc.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window?.rootViewController = navVc
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }

}
