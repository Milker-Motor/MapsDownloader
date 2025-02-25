//
//  DownloadMapsPresenter.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import Foundation

public final class DownloadMapsPresenter {
    private let mapView: MapView
    private let loadingView: MapsLoadingView
    private let errorView: MapsErrorView
    
    public static var title: String { "Download Maps" }
    
    public init(mapView: MapView, loadingView: MapsLoadingView, errorView: MapsErrorView) {
        self.mapView = mapView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public func didStartLoadingMaps() {
        loadingView.display(MapsLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingMaps(with maps: [Map]) {
        loadingView.display(MapsLoadingViewModel(isLoading: false))
        mapView.display(MapsViewModel(maps: maps))
    }
    
    public func didFinishLoadingMaps(with error: Error) {
        loadingView.display(MapsLoadingViewModel(isLoading: false))
        errorView.display(MapsErrorViewModel(text: error.localizedDescription))
    }
}
