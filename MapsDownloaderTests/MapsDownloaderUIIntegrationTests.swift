//
//  MapsDownloaderTests.swift
//  MapsDownloaderTests
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import XCTest
import MapsDownloader

final class MapsDownloaderUIIntegrationTests: XCTestCase {
    func test_mapsDownloaderView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.title, "Download Maps")
    }
    
    func test_loadMapsList_requestMapsFromLoader() {
        let (sut, loader) = makeSUT()

        XCTAssertEqual(loader.loadMapsCallCount, 0, "Expected no loading requests before view is loaded")
    
        sut.simulateAppearance()
        XCTAssertEqual(loader.loadMapsCallCount, 1, "Expected a loading request once view is loaded")
    }
    
    // MARK: - Helpersx
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DownloadMapsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = DownloadMapsComposer.mapsComposedWith(mapsLoader: loader)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (sut, loader)
    }
}

class LoaderSpy: MapsLoader {
    
    var loadMapsCallCount: Int = 0
    
    func load(completion: @escaping (MapsLoader.Result) -> Void) {
        loadMapsCallCount += 1
    }
}
