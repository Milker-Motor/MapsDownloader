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
        completion(.success([Map(name: "1"), Map(name: "12"), Map(name: "13")]))
    }
    
}

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
