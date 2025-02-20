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
        replaceRefreshControllerWithFakeForiOS17Support()
        
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    private func replaceRefreshControllerWithFakeForiOS17Support() {
        let fakeRefreshController = FakeRefreshControl()
        
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fakeRefreshController.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        
        refreshControl = fakeRefreshController
    }
}

private final class FakeRefreshControl: UIRefreshControl {
    var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
