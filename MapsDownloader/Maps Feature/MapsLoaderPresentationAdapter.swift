//
//  MapsLoaderPresentationAdapter.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import Foundation

final class MapsLoaderPresentationAdapter {
    private let mapsLoader: MapsLoader
    var presenter: DownloadMapsPresenter?
    
    init(mapsLoader: MapsLoader) {
        self.mapsLoader = mapsLoader
    }
}

extension MapsLoaderPresentationAdapter: DownloadMapsViewControllerDelegate {
    func didRequestMapsLoad() {
        presenter?.didStartLoadingMaps()
        mapsLoader.load { [weak presenter] result in
            presenter?.didFinishLoadingMaps()
        }
    }
}
