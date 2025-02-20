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
        let sut = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.title, "Download Maps")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> DownloadMapsViewController {
        let sut = DownloadMapsComposer.makeDownloadMapsViewController()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
