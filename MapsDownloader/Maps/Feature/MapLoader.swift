//
//  MapLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 23.02.2025.
//

import Foundation

public protocol MapLoader {
    func load(model: Map, progress: @escaping (Progress) -> Void, completion: @escaping (Error?) -> Void)
    func cancel(model: Map)
}
