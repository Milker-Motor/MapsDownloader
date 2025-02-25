//
//  MapLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 23.02.2025.
//

import Foundation

public protocol MapLoader {
    func load(region: String, parentRegion: String?, progress: @escaping (Progress) -> Void, completion: @escaping (Error?) -> Void)
    func cancel(region: String, parentRegion: String?)
}
