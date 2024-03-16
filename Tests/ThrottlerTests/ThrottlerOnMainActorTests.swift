//
//  ThrottlerOnMainActorTests.swift
//  ThrottlerTests
//

import Foundation

import XCTest

@testable import Throttler

final class ThrottlerOnMainActorTests: XCTestCase {

    private var value = ""
    private var fulfilmentCount = 0

    override func tearDown() async throws {
        try await super.tearDown()

        value = ""
        fulfilmentCount = 0
    }

    // MARK: - Should Not Run The Last Work

    @MainActor
    func test_should_not_run_latest() async {
        let exp = expectation(description: "Ensure first task fired")
        exp.expectedFulfillmentCount = 2

        let throttler = Throttler(duration: .seconds(1), latest: false, clock: .suspending)

        func sendToServer(_ input: String) async {
            await throttler.submit { [self] in
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

        try? await Task.sleep(until: .now + .seconds(2), clock: .suspending)

        await sendToServer("f")
        await sendToServer("g")

        await fulfillment(of: [exp], timeout: 10)
    }

    @MainActor
    func test_should_not_run_latest_multiple_times() async {
        let exp = expectation(description: "Ensure first task fired")
        exp.expectedFulfillmentCount = 2

        let throttler = Throttler(duration: .seconds(1), latest: false, clock: .suspending)

        func sendToServer(_ input: String) async {
            await throttler.submit { [self] in
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

        try? await Task.sleep(until: .now + .seconds(3), clock: .suspending)

        await sendToServer("f")
        await sendToServer("g")

        await fulfillment(of: [exp], timeout: 10)
    }

    // MARK: - Should Run The Last Work

    @MainActor
    func test_should_run_first_and_latest_once() async {
        let exp = expectation(description: "Ensure first task fired")
        exp.expectedFulfillmentCount = 3

        let throttler = Throttler(duration: .seconds(2), latest: true, clock: .suspending)

        func sendToServer(_ input: String) async {
            await throttler.submit { [self] in
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

        try? await Task.sleep(until: .now + .seconds(3), clock: .suspending)

        await sendToServer("f")

        try? await Task.sleep(until: .now + .seconds(3), clock: .suspending)

        await fulfillment(of: [exp], timeout: 10)
    }

    @MainActor
    func test_should_run_first_and_latest_multiple_times() async {
        let exp = expectation(description: "Ensure task fired")
        exp.expectedFulfillmentCount = 4

        let throttler = Throttler(duration: .seconds(2), latest: true, clock: .suspending)

        func sendToServer(_ input: String) async {
            await throttler.submit { [self] in
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

        try? await Task.sleep(until: .now + .seconds(3), clock: .suspending)

        await sendToServer("f")
        await sendToServer("g")

        try? await Task.sleep(until: .now + .seconds(3), clock: .suspending)

        await fulfillment(of: [exp], timeout: 10)
    }

}
