//
//  MapsLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import Foundation

public struct Map: Hashable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}

public protocol MapsLoader {
    typealias Result = Swift.Result<[Map], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
