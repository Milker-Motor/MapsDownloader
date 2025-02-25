//
//  MapEndpointTests.swift
//  MapsDownloaderTests
//
//  Created by Oleksii Lytvynov-Bohdanov on 23.02.2025.
//

import XCTest
import MapsDownloader

class FeedEndpointTests: XCTestCase {
    
    func test_map_endpointURLWithRegionOnly() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = MapEndpoint.get(parentRegion: nil, region: "france").url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.query, "standard=yes&file=France_europe_2.obf.zip", "query")
    }
    
    func test_map_endpointURLWithRegionAndHolder() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = MapEndpoint.get(parentRegion: "france", region: "corse").url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.query, "standard=yes&file=France_corse_europe_2.obf.zip", "query")
    }
    
}
