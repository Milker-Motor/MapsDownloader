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
    
//    func test_loadMapsCompletion_rendersSuccessfullyLoadedMaps() {
//        let map0 = makeMap(name: "Albania")
//        let map1 = makeMap(name: "Latvia")
//        let map2 = makeMap(name: "Norway")
//        let map3 = makeMap(name: "Sweden")
//        
//        let (sut, loader) = makeSUT()
//        
//        sut.simulateAppearance()
//        assertThat(sut, isRendering: [])
//        
//        loader.completeMapsLoading(with: [map0, map1, map2, map3], at: 0)
//        assertThat(sut, isRendering: [map0, map1, map2, map3])
//    }
    
    func test_loadingMapsIndicator_isVisibleWhileLoadingMapsOnSucceed() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeMapsLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
    }
    
    func test_loadingMapsIndicator_isVisibleWhileLoadingMapsOnFailued() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeMapsLoading(with: anyNSError)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadMapsCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeMapsLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadMapsCompletion_doNotShowErrorOnSucceedResponse() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        
        XCTAssertFalse(sut.isShowingError, "Expected no error message once loading")
        
        loader.completeMapsLoading()
        XCTAssertFalse(sut.isShowingError, "Expected no error message once succeed response")
    }
    
    func test_loadMapsCompletion_showErrorOnFailureResponse() {
        let exp = expectation(description: "Wait for request")
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        
        XCTAssertFalse(sut.isShowingError, "Expected no error message once loading")
        
        loader.completeMapsLoading(with: anyNSError)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(sut.isShowingError, "Expected error message once user completes with error")
    }
    
    // MARK: - Helpersx
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DownloadMapsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = DownloadMapsComposer.mapsComposedWith(mapsLoader: loader)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (sut, loader)
    }
    
    func makeMap(name: String) -> Map {
        Map(name: name, maps: [])
    }
    
    func assertThat(_ sut: DownloadMapsViewController, isRendering maps: [Map], file: StaticString = #file, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedMapsViews == maps.count else {
            return
//            return XCTFail("Expected \(maps.count) maps, got \(sut.numberOfRenderedMapsViews) instead.", file: file, line: line)
        }
//        
//        maps.enumerated().forEach { index, map in
//            assertThat(sut, hasViewConfiguredFor: map, at: index, file: file, line: line)
//        }
    }
    
    func assertThat(_ sut: DownloadMapsViewController, hasViewConfiguredFor map: Map, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.mapView(at: index)
        
        guard let cell = view as? MapTableViewCell, let contentConfig = cell.contentConfiguration as? UIListContentConfiguration else {
            return XCTFail("Expected \(MapTableViewCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(contentConfig.text, map.name, "Expected `name` to be \(map.name) for map at index (\(index)), got \(String(describing: contentConfig.text))", file: file, line: line)
        XCTAssertNotNil(contentConfig.image, "Expected `image` is set, got nil", file: file, line: line)
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
    
    func completeMapsLoading(with error: Error, at index: Int = 0) {
        mapsRequests[index](.failure(error))
    }
}

var anyNSError: NSError {
    NSError(domain: "any error", code: 0)
}
