//
//  HTTPClient.swift
//  NetworkingService
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import Foundation

public protocol HTTPClientTask {
    var progress: Progress { get }
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
