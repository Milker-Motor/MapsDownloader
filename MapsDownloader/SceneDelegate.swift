//
//  SceneDelegate.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var regionLoader = LocalRegionLoader()
    private lazy var mapLoader = RemoteMapLoader()
    private lazy var navigationController = {
        let nc = UINavigationController(
            rootViewController: DownloadMapsComposer.mapsComposedWith(
                regionLoader: regionLoader,
                mapLoader: mapLoader,
                selection: showMaps
            )
        )
        nc.navigationBar.tintColor = .white
        nc.navigationBar.backgroundColor = .navigationBar
        nc.navigationBar.barTintColor = .white
        nc.view.backgroundColor = .navigationBar
        nc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        nc.navigationBar.isTranslucent = false
        
        return nc
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showMaps(for map: Map) {
        let maps = DownloadMapsComposer.mapsDetail(
            with: map.maps,
            mapLoader: mapLoader,
            regionLoader: regionLoader
        )
        maps.title = map.name
        navigationController.pushViewController(maps, animated: true)
    }
}
