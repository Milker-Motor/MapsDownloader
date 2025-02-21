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

extension MainQueueDispatchDecorator: MapsLoader where T == MapsLoader {
    
    func load(completion: @escaping (MapsLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
