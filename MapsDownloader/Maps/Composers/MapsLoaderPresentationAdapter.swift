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
            case let .success(regions):
                presenter?.didFinishLoadingMaps(with: regions.toMap())
                
            case let .failure(error):
                presenter?.didFinishLoadingMaps(with: error)
            }
        }
    }
}

extension Array where Element == Region {
    func toMap() -> [Map] {
        map { region in
            Map(name: region.name, parent: region.parent, maps: region.regions.toMap())
        }
    }
}

extension MapsLoaderPresentationAdapter: MapCellControllerDelegate {
    func didRequestMap(cellModel: MapCellModel, progress: @escaping (Progress) -> Void, completion: @escaping ((any Error)?) -> Void) {
        mapLoader.load(region: cellModel.name, parentRegion: cellModel.parent, progress: progress, completion: completion)
    }
    
    func didCancelIMapRequest(model: MapCellModel) {
        mapLoader.cancel(region: model.name, parentRegion: model.parent)
    }
}
