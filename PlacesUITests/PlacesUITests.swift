//
//  PlacesUITests.swift
//  PlacesUITests
//
//

import XCTest

final class PlacesUITests: XCTestCase {
    func testNearbyPlacesOnAppLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let element = app.navigationBars.staticTexts["Popular Nearby Places"].firstMatch
        XCTAssertTrue(element.waitForExistence(timeout: 5), "screen title")
        XCTAssert(app.cells.count > 0, "should load some nearby places based on ip address")
    }
}
