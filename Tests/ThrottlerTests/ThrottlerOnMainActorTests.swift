//
//  ThrottlerOnMainActorTests.swift
//  ThrottlerTests
//

import Foundation

import XCTest

@testable import Throttler

@MainActor
final class ThrottlerOnMainActorTests: XCTestCase {

    // MARK: - Should Not Run The Last Work

    func test_should_not_run_latest() async {
        let exp = expectation(description: "Ensure first task fired")
        exp.expectedFulfillmentCount = 2

        let throttler = Throttler(duration: 1, latest: false)

        var value = ""
        var fulfilmentCount = 0

        func sendToServer(_ input: String) async {
            await throttler.submit {
                value += input

                switch fulfilmentCount {
                case 0:
                    XCTAssertEqual(value, "a")
                case 1:
                    XCTAssertEqual(value, "af")
                default:
                    XCTFail()
                }

                exp.fulfill()
                fulfilmentCount += 1
            }
        }

        await sendToServer("a")
        await sendToServer("b")
        await sendToServer("c")
        await sendToServer("d")
        await sendToServer("e")

        try? await Task.sleep(until: .now +  .seconds(2), clock: .suspending)

        await sendToServer("f")
        await sendToServer("g")

        wait(for: [exp], timeout: 10)
    }

    func test_should_not_run_latest_multiple_times() async {
        let exp = expectation(description: "Ensure first task fired")
        exp.expectedFulfillmentCount = 2

        let throttler = Throttler(duration: 1, latest: false)

        var value = ""
        var fulfilmentCount = 0

        func sendToServer(_ input: String) async {
            await throttler.submit {
                value += input

                switch fulfilmentCount {
                case 0:
                    XCTAssertEqual(value, "a")
                case 1:
                    XCTAssertEqual(value, "af")
                default:
                    XCTFail()
                }

                exp.fulfill()
                fulfilmentCount += 1
            }
        }

        await sendToServer("a")
        await sendToServer("b")
        await sendToServer("c")
        await sendToServer("d")
        await sendToServer("e")

        try? await Task.sleep(until: .now +  .seconds(3), clock: .suspending)

        await sendToServer("f")
        await sendToServer("g")

        wait(for: [exp], timeout: 10)
    }

    // MARK: - Should Run The Last Work

    func test_should_run_first_and_latest_once() async {
        let exp = expectation(description: "Ensure first task fired")
        exp.expectedFulfillmentCount = 3

        let throttler = Throttler(duration: 2, latest: true)

        var value = ""
        var fulfilmentCount = 0

        func sendToServer(_ input: String) async {
            await throttler.submit {
                value += input

                switch fulfilmentCount {
                case 0:
                    XCTAssertEqual(value, "a")
                case 1:
                    XCTAssertEqual(value, "ae")
                case 2:
                    XCTAssertEqual(value, "aef")
                default:
                   XCTFail()
                }

                exp.fulfill()
                fulfilmentCount += 1
            }
        }

        await sendToServer("a")
        await sendToServer("b")
        await sendToServer("c")
        await sendToServer("d")
        await sendToServer("e")

        try? await Task.sleep(until: .now +  .seconds(3), clock: .suspending)

        await sendToServer("f")

        try? await Task.sleep(until: .now +  .seconds(3), clock: .suspending)

        wait(for: [exp], timeout: 10)
    }

    func test_should_run_first_and_latest_multiple_times() async {
        let exp = expectation(description: "Ensure task fired")
        exp.expectedFulfillmentCount = 4

        let throttler = Throttler(duration: 2, latest: true)

        var value = ""
        var fulfilmentCount = 0

        func sendToServer(_ input: String) async {
            await throttler.submit {
                value += input

                switch fulfilmentCount {
                case 0:
                    XCTAssertEqual(value, "a")
                case 1:
                    XCTAssertEqual(value, "ae")
                case 2:
                    XCTAssertEqual(value, "aef")
                case 3:
                    XCTAssertEqual(value, "aefg")
                default:
                    XCTFail()
                }

                exp.fulfill()
                fulfilmentCount += 1
            }
        }

        await sendToServer("a")
        await sendToServer("b")
        await sendToServer("c")
        await sendToServer("d")
        await sendToServer("e")

        try? await Task.sleep(until: .now +  .seconds(3), clock: .suspending)

        await sendToServer("f")
        await sendToServer("g")

        try? await Task.sleep(until: .now +  .seconds(3), clock: .suspending)

        wait(for: [exp], timeout: 10)
    }

}
