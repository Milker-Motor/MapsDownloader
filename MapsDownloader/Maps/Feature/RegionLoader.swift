//
//  MapsLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import Foundation

public protocol RegionLoader {
    typealias Result = Swift.Result<[Map], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
