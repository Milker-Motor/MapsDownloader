//
//  SceneDelegate.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = UINavigationController(
            
            rootViewController: DownloadMapsComposer.makeDownloadMapsViewController()
        )
        window?.makeKeyAndVisible()
    }
    
    
}

public final class DownloadMapsComposer {
    public static func makeDownloadMapsViewController() -> DownloadMapsViewController {
        let downloadMapsViewController = DownloadMapsViewController()
        
        downloadMapsViewController.title = DownloadMapsPresenter.title
        
        return downloadMapsViewController
    }
}

public final class DownloadMapsPresenter {
    public static var title: String { "Download Maps" }
}
