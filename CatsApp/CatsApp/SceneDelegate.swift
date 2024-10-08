//
//  SceneDelegate.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var catsController = UINavigationController(
        rootViewController: CatsComposer.catsComposedWith(
            client: httpClient,
            breedsLoader: BreedsNetworkService(),
            breedImageLoader: BreedImageNetworkService(),
            persistenceLoader: PersistenceService(),
            selection: navigateToBreedDetails
        )
    )
    
    private lazy var favoriteController = UINavigationController(
        rootViewController: FavoriteComposer.favoriteComposedWith(
            persistenceLoader: PersistenceService(),
            selection: navigateToBreedDetails
        )
    )
    
    private lazy var tabBarController = UITabBarController()
        
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .default))
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        configureTabBar()
        configureWindow()
    }
    
    public func configureWindow() {
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func configureTabBar() {
        catsController.tabBarItem = UITabBarItem(title: "Cats list", image: UIImage(systemName: "cat"), tag: 0)
        favoriteController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), tag: 1)
        tabBarController.viewControllers = [catsController, favoriteController]
    }
    
    private func navigateToBreedDetails(breed: CatBreed) {
        let hostingController =  BreedDetailsComposer.detailsComposedWith(breed: breed, persistenceLoader: PersistenceService())
        if let selectedViewController = tabBarController.selectedViewController as? UINavigationController {
            selectedViewController.pushViewController(hostingController, animated: true)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

