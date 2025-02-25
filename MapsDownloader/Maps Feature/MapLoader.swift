//
//  MapLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 23.02.2025.
//

import Foundation
import NetworkingService

//public protocol MapLoaderTask {
//    func cancel()
//}

public protocol MapLoader {
    func load(model: Map, progress: @escaping (Progress) -> Void)
    func cancel(model: Map)
}

final class RemoteMapLoader: MapLoader {
    private var tasksToDownload: [(url: URL, task: HTTPClientTask?)] = []
    private lazy var baseURL = URL(string: "https://download.osmand.net/download")!
    
    private var observation: NSKeyValueObservation?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    func load(model: Map, progress: @escaping (Progress) -> Void) {
        let url = MapEndpoint.get(holder: model.parent, region: model.name).url(baseURL: baseURL)
        tasksToDownload.append((url, nil))
        guard tasksToDownload.count == 1, let task = loadNext() else { return }
        
        observation = task.progress.observe(\.fractionCompleted, options: [.new]) { prog, _ in
            progress(prog)
        }
        tasksToDownload.removeLast()
        tasksToDownload.append((url, task))
    }
    
    @discardableResult
    private func loadNext() -> HTTPClientTask? {
        guard let url = tasksToDownload.first?.url else { return nil }
        
        let task = httpClient.get(from: url) { [weak self] response in
            self?.tasksToDownload.removeAll { $0.url == url }
            self?.loadNext()
        }
        
        return task
    }
    
    func cancel(model: Map) {
        let url = MapEndpoint.get(holder: model.parent, region: model.name).url(baseURL: baseURL)
        tasksToDownload.first { $0.url == url }?.task?.cancel()
        tasksToDownload.removeAll { $0.url == url }
    }
}

public enum MapEndpoint {
    case get(holder: String?, region: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(holder, region):
            let fileName = [holder, region, "europe", "2"].compactMap { $0 }.joined(separator: "_") + ".obf.zip"
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path
            components.queryItems = [
                URLQueryItem(name: "standard", value: "yes"),
                URLQueryItem(name: "file", value: fileName)
            ]
            return components.url!
        }
    }
}
