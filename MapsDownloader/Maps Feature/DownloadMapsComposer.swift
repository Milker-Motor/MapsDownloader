//
//  DownloadMapsComposer.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import Foundation

public final class DownloadMapsComposer {
    static func mapsDetail() -> MapsDetailTableViewController {
        MapsDetailTableViewController()
    }
    
    public static func mapsComposedWith(mapsLoader: MapsLoader, selection: @escaping (Map) -> Void = { _ in } ) -> DownloadMapsViewController {

        let presentationAdapter = MapsLoaderPresentationAdapter(mapsLoader: MainQueueDispatchDecorator(decoratee: mapsLoader), selection: selection)
        let mapsController = makeDownloadMapsViewController(delegate: presentationAdapter)
        
        presentationAdapter.presenter = DownloadMapsPresenter(
            mapView: MapViewAdapter(controller: mapsController, selection: selection),
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
