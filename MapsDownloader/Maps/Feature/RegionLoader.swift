//
//  MapsLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import Foundation

public struct Region {
    public let name: String
    public let parent: String?
    public let regions: [Region]
    
    public init(name: String, parent: String?, regions: [Region]) {
        self.name = name
        self.parent = parent
        self.regions = regions
    }
}

public protocol RegionLoader {
    typealias Result = Swift.Result<[Region], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
