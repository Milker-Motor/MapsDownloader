//
//  MainQueueDispatchDecorator.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.sync(execute: completion) }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: RegionLoader where T == RegionLoader {
    func load(completion: @escaping (RegionLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: MapLoader where T == MapLoader {
    func cancel(region: String, parentRegion: String?) {
        decoratee.cancel(region: region, parentRegion: parentRegion
        )
    }
    
    func load(region: String, parentRegion: String?, progress: @escaping (Progress) -> Void, completion: @escaping ((any Error)?) -> Void) {
        decoratee.load(region: region, parentRegion: parentRegion) { [weak self] prog in
            self?.dispatch {
                progress(prog)
            }
        } completion: { [weak self] error in
            self?.dispatch {
                completion(error)
            }
        }

    }
}
