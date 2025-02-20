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
    
    func test_loadingIndicator_isVisibleWhileLoadingMaps() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeMapsLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes")
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
    
    private var mapsRequests = [(MapsLoader.Result) -> Void]()
    var loadMapsCallCount: Int { mapsRequests.count }
    
    func load(completion: @escaping (MapsLoader.Result) -> Void) {
        mapsRequests.append(completion)
    }
    
    func completeMapsLoading(with maps: [Map] = [], at index: Int = 0) {
        mapsRequests[index](.success(maps))
    }
}
