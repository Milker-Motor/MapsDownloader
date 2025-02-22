//
//  MapLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 23.02.2025.
//

import Foundation
import NetworkingService

protocol MapLoader {
    func load(from url: URL)
}

final class RemoteMapLoader: MapLoader {
    private var urlsToDownload: [URL] = []
    private lazy var baseURL = URL(string: "https://download.osmand.net/download")!
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    func load(from url: URL) {
        urlsToDownload.append(url)
        loadNext()
    }
    
    func loadNext() {
        guard let url = urlsToDownload.first else { return }
        
        httpClient.get(from: url) { [weak self] response in
            self?.urlsToDownload.removeAll { $0 == url }
            self?.loadNext()
        }
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
