//
//  DetailMapViewAdapter.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 25.02.2025.
//

import Foundation

final class DetailMapViewAdapter: MapView {
    private weak var controller: MapsTableViewController?
    private let selection: (Map) -> Void
    private let regionLoader: RegionLoader
    private let mapLoader: MapLoader
    
    init(controller: MapsTableViewController, regionLoader: RegionLoader, mapLoader: MapLoader, selection: @escaping (Map) -> Void) {
        self.controller = controller
        self.regionLoader = regionLoader
        self.mapLoader = mapLoader
        self.selection = selection
    }
    
    public func display(_ viewModel: MapsViewModel) {
        let mapsAdapter = MapsLoaderPresentationAdapter(regionLoader: regionLoader, mapLoader: mapLoader, selection: selection)
        
        let mapsSection = viewModel.maps.map { viewModel in
            CellController(id: viewModel, MapCellController(model: MapCellModel(name: viewModel.name, parent: viewModel.parent, isMapAvailable: viewModel.isMapAvailable), header: "REGIONS", delegate: mapsAdapter, selection: { [weak self] _ in self?.selection(viewModel)
            }))
        }
        
        controller?.display(mapsSection)
    }
}
