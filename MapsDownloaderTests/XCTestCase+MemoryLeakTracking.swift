//
//  XCTestCase+MemoryLeakTracking.swift
//  MapsDownloaderTests
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
