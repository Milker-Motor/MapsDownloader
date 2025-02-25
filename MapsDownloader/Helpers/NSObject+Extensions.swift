//
//  NSObject+Extensions.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 25.02.2025.
//

import Foundation

extension NSObject {
    static var classString: String {
        String(describing: self.self)
    }
}
