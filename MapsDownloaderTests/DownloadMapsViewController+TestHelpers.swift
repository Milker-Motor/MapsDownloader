//
//  DownloadMapsViewController+TestHelpers.swift
//  MapsDownloaderTests
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import UIKit
import MapsDownloader

extension DownloadMapsViewController {
    func simulateAppearance() {
        loadViewIfNeeded()        
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}
