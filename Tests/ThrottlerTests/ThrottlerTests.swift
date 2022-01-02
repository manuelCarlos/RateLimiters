//
//  ThrottlerTests.swift
//  ThrottlerTests
//

import XCTest

@testable import Throttler

@available(iOS 13.0, *)
final class ThrottlerTests: XCTestCase {

    func test_test_should_not_run_immediately_and_not_latest() {
        let interval: TimeInterval = 10

        let exp = expectation(description: "exp")

        var sum = 0
        for i in 0...5 {
            print("for loop : \(i)")

            Throttler.throttle(id: "throttle-test1",
                               delay: .seconds(5),
                               shouldRunImmediately: false,
                               shouldRunLatest: false,
                               queue: .global()) {
                sum += 1
                if sum == 1 {
                    exp.fulfill()
                }
            }
        }

        waitForExpectations(timeout: interval)
        XCTAssertEqual(sum, 1)
    }

    func test_should_not_run_immediately_and_latest() {
        let interval: TimeInterval = 10
        let exp3 = expectation(description: "exp3")

        var sum3 = 0
        for i in 0...5 {

            // shouldRunImmediately: true, shouldRunLatest: true by default.
            Throttler.throttle(id: "throttle-test3",
                               delay: .seconds(1),
                               shouldRunImmediately: false) {
                sum3 += 1
                print("sum3 : \(sum3)")

                if i == 5 {
                    exp3.fulfill()
                }
            }
        }

        waitForExpectations(timeout: interval)
        XCTAssertEqual(sum3, 1)
    }

    func test_should_run_immediately_and_latest() {
        let interval: TimeInterval = 10
        let exp2 = expectation(description: "exp2")

        var sum2 = 0
        for i in 0...5 {
            print("for loop : \(i)")

            // shouldRunImmediately: true, shouldRunLatest: true by default.
            Throttler.throttle(id: "throttle-test2") {
                sum2 += 1

                if i == 5 {
                    exp2.fulfill()
                }
            }
        }

        waitForExpectations(timeout: interval)
        XCTAssertEqual(sum2, 2)
    }

    func test_should_start_immediately() {
        let interval: TimeInterval = 5
        let exp = expectation(description: "exp")

        var sum = 0
        for i in 0...1000 {
            // note: shouldStartImmediately is true by default.
            Throttler.throttle(id: "throttle-test4",
                               delay:.seconds(3),
                               queue: .global()) {
                sum += 1
            }

            if i == 1000 {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: interval)
        XCTAssertNotEqual(sum, 1001)

        //-------------------------------------------------------//

        var sum2 = 0
        Throttler.throttle(id: "throttle-test5",
                           shouldRunImmediately: false) {
            sum2 += 1
        }
        XCTAssertEqual(sum2, 0)

        //-------------------------------------------------------//

        // shouldRunImmediately is true by default.
        var sum22 = 0
        Throttler.throttle(id: "throttle-test6") {
            sum22 += 1
        }
        XCTAssertEqual(sum22, 1)

        //-------------------------------------------------------//

        let exp3 = expectation(description: "exp3")
        var sum3 = 0
        for i in 0...10 {
            Throttler.throttle(id: "throttle-test7",
                               delay: .seconds(2),
                               shouldRunLatest: true) {
                sum3 = i

                if i == 10 {
                    exp3.fulfill()
                }
            }
        }
        waitForExpectations(timeout: interval)
        XCTAssertEqual(sum3, 10)

        //-------------------------------------------------------//

        let exp4 = expectation(description: "exp4")
        let count4 = 10000
        var sum4 = 0

        for i in 0...count4 {
            Throttler.throttle(id: "throttle-test8",
                               delay: .seconds(5.0),
                               shouldRunLatest: false) {
                sum4 = i
            }

            if i == count4 {
                exp4.fulfill()
            }
        }
        waitForExpectations(timeout: 100.0)
        XCTAssertNotEqual(sum4, count4)
    }
}
