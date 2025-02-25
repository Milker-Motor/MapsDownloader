//
//  DownloadMapsComposer.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import Foundation

public final class DownloadMapsComposer {
    static func mapsDetail(with maps: [Map], mapLoader: MapLoader, regionLoader: RegionLoader) -> MapsDetailTableViewController {
        let mapsController = MapsDetailTableViewController()
        let viewAdapter = DetailMapViewAdapter(
            controller: mapsController,
            regionLoader: regionLoader,
            mapLoader: mapLoader,
            selection: { _ in }
        )
        viewAdapter.display(MapsViewModel(maps: maps))
        
        return mapsController
    }
    
    public static func mapsComposedWith(regionLoader: RegionLoader, mapLoader: MapLoader, selection: @escaping (Map) -> Void) -> DownloadMapsViewController {

        let presentationAdapter = MapsLoaderPresentationAdapter(
            regionLoader: MainQueueDispatchDecorator(decoratee: regionLoader),
            mapLoader: mapLoader,
            selection: selection
        )
        let mapsController = makeDownloadMapsViewController(delegate: presentationAdapter)
        
        presentationAdapter.presenter = DownloadMapsPresenter(
            mapView: MapViewAdapter(
                controller: mapsController.mapsController,
                regionLoader: regionLoader,
                mapLoader: mapLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(mapsController),
            errorView: WeakRefVirtualProxy(mapsController))
    
        return mapsController
    }
    
    private static func makeDownloadMapsViewController(delegate: DownloadMapsViewControllerDelegate) -> DownloadMapsViewController {
        let downloadMapsViewController = DownloadMapsViewController()
        
        downloadMapsViewController.title = DownloadMapsPresenter.title
        downloadMapsViewController.delegate = delegate
        
        return downloadMapsViewController
    }
}
