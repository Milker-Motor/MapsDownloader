//
//  MapEndpoint.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 25.02.2025.
//

import Foundation

public enum MapEndpoint {
    case get(holder: String?, region: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(holder, region):
            let fileName = [holder, region, "europe", "2"].compactMap { $0 }.joined(separator: "_").capitalized(with: nil) + ".obf.zip"
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
