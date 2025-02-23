//
//  URLSessionHTTPClient.swift
//  NetworkingService
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        var progress: Progress {
            wrapped.progress
        }
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        print("did start ")
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    print("did end with error")
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("did end with data")
                    return (data, response)
                } else {
                    print("did end with unexpected error")
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        
        return URLSessionTaskWrapper(wrapped: task)
    }
}
