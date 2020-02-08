//
//  FugenDemoTests.swift
//  FugenDemoTests
//
//  Created by Almaz Ibragimov on 08.02.2020.
//  Copyright © 2020 Almaz Ibragimov. All rights reserved.
//

import XCTest
import FugenDemo

class FugenDemoTests: XCTestCase {

    func testImages() {
        do {
            try Images.validate()
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testTextStyles() {
        do {
            try TextStyle.validate()
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
}
