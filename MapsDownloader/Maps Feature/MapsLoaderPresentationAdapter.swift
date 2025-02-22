//
//  MapsLoaderPresentationAdapter.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import Foundation

final class MapsLoaderPresentationAdapter {
    private let mapsLoader: RegionLoader
    private let selection: (Map) -> Void
    
    var presenter: DownloadMapsPresenter?
    
    init(mapsLoader: RegionLoader, selection: @escaping (Map) -> Void) {
        self.mapsLoader = mapsLoader
        self.selection = selection
    }
}

extension MapsLoaderPresentationAdapter: DownloadMapsViewControllerDelegate {
    func didRequestMapsLoad() {
        presenter?.didStartLoadingMaps()
        mapsLoader.load { [weak presenter] result in
            switch result {
            case let .success(maps):
                presenter?.didFinishLoadingMaps(with: maps)
                
            case let .failure(error):
                presenter?.didFinishLoadingMaps(with: error)
            }
        }
    }
}
