//
//  DownloadMapsComposer.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import Foundation

public final class DownloadMapsComposer {
    public static func mapsComposedWith(mapsLoader: MapsLoader) -> DownloadMapsViewController {

        let presentationAdapter = MapsLoaderPresentationAdapter(mapsLoader: mapsLoader)
        
        
        let mapsController = makeDownloadMapsViewController(delegate: presentationAdapter)
        presentationAdapter.presenter = DownloadMapsPresenter(
            mapView: WeakRefVirtualProxy(mapsController),
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
