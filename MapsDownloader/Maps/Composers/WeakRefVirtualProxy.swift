//
//  WeakRefVirtualProxy.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 25.02.2025.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: MapsLoadingView where T: MapsLoadingView {
    func display(_ viewModel: MapsLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: MapsErrorView where T: MapsErrorView {
    func display(_ viewModel: MapsErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: MapView where T: MapView {
    func display(_ viewModel: MapsViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: DownloadMapsViewControllerDelegate where T: DownloadMapsViewControllerDelegate {
    func didRequestMapsLoad() {
        object?.didRequestMapsLoad()
    }
    
    
}
