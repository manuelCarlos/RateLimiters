//
//  DebouncerTests.swift
//  DebouncerTests
//

import XCTest

@testable import Debouncer

final class DebouncerTests: XCTestCase {

    func test_debouncer() async throws {
        let exp = expectation(description: "Ensure last task fired")
        exp.expectedFulfillmentCount = 2

        let debouncer = Debouncer(duration: 1)

        var value = ""
        var fulfilmentCount = 0

        func sendToServer(_ input: String) async {
            await debouncer.submit {
                value += input

                switch fulfilmentCount {
                case 0:
                    XCTAssertEqual(value, "e")
                case 1:
                    XCTAssertEqual(value, "eg")
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

        try? await Task.sleep(until: .now +  .seconds(2), clock: .suspending)

        wait(for: [exp], timeout: 10)
    }

    func test_debouncer_after_duration() async throws {
        let exp = expectation(description: "Ensure debounce after duration")
        let debouncer = Debouncer(duration: 1)

        var end = Date.now + 1
        exp.expectedFulfillmentCount = 2

        func test() {
            XCTAssertGreaterThanOrEqual(.now, end)
            exp.fulfill()
        }

        await debouncer.submit(operation: test)
        await debouncer.submit(operation: test)
        await debouncer.submit(operation: test)
        await debouncer.submit(operation: test)
        await debouncer.submit(operation: test)

        try? await Task.sleep(until: .now +  .seconds(2), clock: .suspending)
        end = .now + 1

        await debouncer.submit(operation: test)
        await debouncer.submit(operation: test)
        await debouncer.submit(operation: test)

        try? await Task.sleep(until: .now +  .seconds(2), clock: .suspending)

        wait(for: [exp], timeout: 10)
    }

}
