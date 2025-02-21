//
//  UIView+TestHelpers.swift
//  MapsDownloaderTests
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
