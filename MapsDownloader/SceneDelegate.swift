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
            
            rootViewController: DownloadMapsComposer.mapsComposedWith(mapsLoader: LocalMapsLoader())
        )
        window?.makeKeyAndVisible()
    }
}

public class LocalMapsLoader {
    
}

extension LocalMapsLoader: MapsLoader {
    public func load(completion: @escaping (MapsLoader.Result) -> Void) {
        
    }
    
}

public final class DownloadMapsComposer {
    public static func mapsComposedWith(mapsLoader: MapsLoader) -> DownloadMapsViewController {

        let presentationAdapter = MapsLoaderPresentationAdapter(mapsLoader: mapsLoader)
        
        let mapsController = makeDownloadMapsViewController(delegate: presentationAdapter)
    
        return mapsController
    }
    
    private static func makeDownloadMapsViewController(delegate: DownloadMapsViewControllerDelegate) -> DownloadMapsViewController {
        let downloadMapsViewController = DownloadMapsViewController()
        
        downloadMapsViewController.title = DownloadMapsPresenter.title
        downloadMapsViewController.delegate = delegate
        
        return downloadMapsViewController
    }
}

public final class DownloadMapsPresenter {
    public static var title: String { "Download Maps" }
}
