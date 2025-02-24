//
//  MapsLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import Foundation

public struct Map: Hashable {
    public let name: String
    public let parent: String?
//    public let flagImageName: String
    public let maps: [Map]
    var isDownloaded: Bool = false
    public var isMapAvailable: Bool { maps.isEmpty }
    
    public init(name: String, parent: String?, maps: [Map]) {
        self.name = name
        self.parent = parent
//        self.flagImageName = "ic_custom_show_on_map"
        self.maps = maps
    }
}

public protocol RegionLoader {
    typealias Result = Swift.Result<[Map], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
