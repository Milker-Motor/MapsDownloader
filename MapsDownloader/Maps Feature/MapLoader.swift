//
//  MapLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 23.02.2025.
//

import Foundation

protocol MapLoader {
    func load(from url: URL)
}

final class RemoteMapLoader: MapLoader {
    private lazy var baseURL = URL(string: "https://download.osmand.net/download")!
//https://download.osmand.net/download?standard=yes&file=Germany_berlin_europe_2.obf.zip
    func load(from url: URL) {
        
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
