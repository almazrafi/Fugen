import XCTest

import FugenTests
import FugenToolsTests

var tests = [XCTestCaseEntry]()
tests += FugenTests.__allTests()
tests += FugenToolsTests.__allTests()

XCTMain(tests)
