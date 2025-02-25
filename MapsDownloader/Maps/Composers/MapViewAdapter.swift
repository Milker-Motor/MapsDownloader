//
//  MapViewAdapter.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 25.02.2025.
//

import Foundation

final class MapViewAdapter: MapView {
    private weak var controller: MapsTableViewController?
    private let selection: (Map) -> Void
    private let regionLoader: RegionLoader
    private let mapLoader: MapLoader
    
    init(controller: MapsTableViewController, regionLoader: RegionLoader, mapLoader: MapLoader, selection: @escaping (Map) -> Void) {
        self.controller = controller
        self.selection = selection
        self.regionLoader = regionLoader
        self.mapLoader = mapLoader
    }
    
    public func display(_ viewModel: MapsViewModel) {
        let freeSpaceSection = [CellController(id: UUID(), StorageCellController())]
        let mapsAdapter = MapsLoaderPresentationAdapter(regionLoader: regionLoader, mapLoader: mapLoader, selection: selection)
        let mapsSection = viewModel.maps.map { viewModel in
            CellController(id: viewModel, MapCellController(model: viewModel, header: "EUROPE", delegate: mapsAdapter, selection: selection))
        }
        
        controller?.display(freeSpaceSection, mapsSection)
    }
}
