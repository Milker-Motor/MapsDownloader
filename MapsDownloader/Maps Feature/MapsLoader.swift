//
//  MapsLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import Foundation

public struct Map: Hashable {
    public let name: String
    public let flagImageName: String
    public let maps: [Map]
    
    public init(name: String, maps: [Map]) {
        self.name = name
        self.flagImageName = "ic_custom_show_on_map"
        self.maps = maps
    }
}

public protocol MapsLoader {
    typealias Result = Swift.Result<[Map], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
