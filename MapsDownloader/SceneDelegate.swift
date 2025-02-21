//
//  SceneDelegate.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var navigationController = {
        let nc = UINavigationController(
            rootViewController: DownloadMapsComposer.mapsComposedWith(
                mapsLoader: LocalMapsLoader(),
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
//        let existedMaps = ExistedMaps(maps: map.maps)
        let maps = DownloadMapsComposer.mapsDetail(with: map.maps)
        maps.title = map.name
        navigationController.pushViewController(maps, animated: true)
//        maps.display(<#T##sections: [CellController]...##[CellController]#>)
    }
}
//
//private class ExistedMaps: MapsLoader {
//    let maps: [Map]
//    init(maps: [Map]) {
//        self.maps = maps
//    }
//    
//    func load(completion: @escaping (MapsLoader.Result) -> Void) {
//        completion(.success(maps))
//    }
//}

public protocol MapsErrorView {
    func display(_ viewModel: MapsErrorViewModel)
}

public struct MapsErrorViewModel {
    public let text: String
}

public protocol MapsLoadingView {
    func display(_ viewModel: MapsLoadingViewModel)
}

public struct MapsLoadingViewModel {
    public let isLoading: Bool
}

public protocol MapView {
    func display(_ viewModel: MapsViewModel)
}

public struct StorageViewModel {
    let freeSpace: NSNumber
    let totalSize: NSNumber
}

public struct MapsViewModel {
    let maps: [Map]
}

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: MapsLoadingView where T: MapsLoadingView {
    func display(_ viewModel: MapsLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: MapsErrorView where T: MapsErrorView {
    func display(_ viewModel: MapsErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: MapView where T: MapView {
    func display(_ viewModel: MapsViewModel) {
        object?.display(viewModel)
    }
}
