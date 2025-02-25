//
//  RemoteMapLoader.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 25.02.2025.
//

import Foundation
import NetworkingService

private final class DownloadTask {
    let url: URL
    let progress: (Progress) -> Void
    let completion: (Error?) -> Void
    var task: HTTPClientTask?
    
    init(url: URL, progress: @escaping (Progress) -> Void, completion: @escaping (Error?) -> Void, task: HTTPClientTask? = nil) {
        self.url = url
        self.progress = progress
        self.completion = completion
        self.task = task
    }
}

final class RemoteMapLoader: MapLoader {
    private var tasksToDownload: [DownloadTask] = []
    private lazy var baseURL = URL(string: "https://download.osmand.net/download")!
    
    private var observation: NSKeyValueObservation?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    func load(region: String, parentRegion: String?, progress: @escaping (Progress) -> Void, completion: @escaping ((any Error)?) -> Void) {
        let url = MapEndpoint.get(parentRegion: parentRegion, region: region).url(baseURL: baseURL)
        let newTask = DownloadTask(url: url, progress: progress, completion: completion)
        tasksToDownload.append(newTask)
        if tasksToDownload.count == 1 {
            loadNext(newTask)
        } else {
            progress(Progress())
        }
    }
    
    @discardableResult
    private func loadNext(_ downloadTask: DownloadTask?) -> HTTPClientTask? {
        guard let downloadTask else { return nil }
        
        let task = httpClient.get(from: downloadTask.url) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    downloadTask.completion(nil)
                case let .failure(error):
                    downloadTask.completion(error)
                }
            }
            self?.tasksToDownload.removeAll { $0.url == downloadTask.url }
            self?.loadNext(self?.tasksToDownload.first)
        }
        downloadTask.task = task
        
        observation = task.progress.observe(\.fractionCompleted, options: [.new]) { prog, _ in
            downloadTask.progress(prog)
        }
        
        return task
    }
    
    func cancel(region: String, parentRegion: String?) {
        let url = MapEndpoint.get(parentRegion: parentRegion, region: region).url(baseURL: baseURL)
        
        if let downloadTask = tasksToDownload.first(where: { $0.url == url }) {
            downloadTask.task?.cancel()
            tasksToDownload.removeAll { $0.url == downloadTask.url }
        }
    }
}
