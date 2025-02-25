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
