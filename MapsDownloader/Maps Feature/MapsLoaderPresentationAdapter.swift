//
//  MapsLoaderPresentationAdapter.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import Foundation

final class MapsLoaderPresentationAdapter {
    private let regionLoader: RegionLoader
    private let mapLoader: MapLoader
    private let selection: (Map) -> Void
    
    var presenter: DownloadMapsPresenter?
    
    init(regionLoader: RegionLoader, mapLoader: MapLoader, selection: @escaping (Map) -> Void) {
        self.regionLoader = regionLoader
        self.mapLoader = mapLoader
        self.selection = selection
    }
}

extension MapsLoaderPresentationAdapter: DownloadMapsViewControllerDelegate {
    func didRequestMapsLoad() {
        presenter?.didStartLoadingMaps()
        regionLoader.load { [weak presenter] result in
            switch result {
            case let .success(maps):
                presenter?.didFinishLoadingMaps(with: maps)
                
            case let .failure(error):
                presenter?.didFinishLoadingMaps(with: error)
            }
        }
    }
}

extension MapsLoaderPresentationAdapter: MapCellControllerDelegate {
    func didRequestMap(map: Map) {
        mapLoader.load(model: map)
    }
    
    func didCancelIMapRequest(map: Map) {
        mapLoader.cancel(model: map)
    }
}
