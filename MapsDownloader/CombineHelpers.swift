//
//  CombineHelpers.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import Foundation
import Combine
import NetworkingService

public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(url: URL) -> Publisher {
        var task: HTTPClientTask?
        
        return Deferred {
            Future { completion in
                task = self.get(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}
