//
//  PercentageTests.swift
//  Currencies
//
//  Created by Flemming Pedersen on 09/07/2018.
//  Copyright © 2018 Ka-ching. All rights reserved.
//

import XCTest

@testable import Currencies

private struct PercentageWrapper: Codable {
    let amount: Percentage
}

final class PercentageTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        Percentage.locale = Locale(identifier: "en")
    }
    func testCodable() {
        // this is tested indirectly through CurrencyAmountWrapper since currency code is just a string when serialized
        let currencyAmountJSON = "{\"amount\": 10}"
        let decoded = try? JSONDecoder()
            .decode(PercentageWrapper.self, from: currencyAmountJSON.data(using: .utf8)!)  // swiftlint:disable:this force_unwrapping
        XCTAssertNotNil(decoded)

        let encoded = try? JSONEncoder()
            .encode(PercentageWrapper(amount: Percentage(integerLiteral: 10)))
        XCTAssertNotNil(encoded)
    }

    func testInit() {
        let p = Percentage(value: 0.01)
        XCTAssertEqual("1%", p.formatted())
    }

    func testDescription() {
        let p = Percentage(value: 0.2)
        XCTAssertEqual(p.description(scale: 1), p.formatted(scale: 1))
        XCTAssertEqual(p.description, p.playgroundDescription as! String)  //swiftlint:disable:this force_cast
        XCTAssertEqual(p.description, p.debugDescription)
    }

    func testArithmetic() {
        let point001: Percentage = 0.001
        let point002: Percentage = 0.002
        XCTAssertEqual(point001 + point001, point002)
        XCTAssertEqual(point001 - point001, 0)
        XCTAssertEqual(point001 * 10, 0.01)
        XCTAssertEqual(point001 / 10, 0.0001)

        var amount = point001
        amount += point001
        XCTAssertEqual(amount, point002)
        amount -= point001
        XCTAssertEqual(amount, point001)
        amount *= 2
        XCTAssertEqual(amount, point002)
        amount /= 2
        XCTAssertEqual(amount, point001)
        amount = amount * 2  //swiftlint:disable:this shorthand_operator
        XCTAssertEqual(amount, point002)
        amount = amount / 2  //swiftlint:disable:this shorthand_operator
        XCTAssertEqual(amount, point001)
        amount = amount * (2 as Decimal)  //swiftlint:disable:this shorthand_operator
        XCTAssertEqual(amount, point002)
        amount = (2 as Decimal) * amount
        XCTAssertEqual(amount, 0.004)
        amount = amount * (2 as Decimal)
        XCTAssertEqual(amount, 0.008)
        amount = 2 * amount
        XCTAssertEqual(amount, 0.016)
        XCTAssertEqual(2 / point001, 2000)
        XCTAssertEqual(-point001, -0.001)
    }

    func testMutatingConvenienceMethods() {
        // add
        var p: Percentage = 0.01
        p.add(0.01)
        XCTAssertEqual(p, 0.02)

        // sub
        p.subtract(0.01)
        XCTAssertEqual(p, 0.01)

        // multiply
        p.multiply(by: 10)
        XCTAssertEqual(p, 0.1)

        // division
        p.divide(by: 10)
        XCTAssertEqual(p, 0.01)

        // negate
        p.negate()
        XCTAssertEqual(p, -0.01)

        // abs
        XCTAssertEqual(abs(p), 0.01)
        p.negate()
        XCTAssertEqual(abs(p), 0.01)
    }

    func testEqualityConvenienceMethods() {
        // equal
        let p: Percentage = 0.01
        let q: Percentage = -0.01
        XCTAssertTrue(p.isEqual(to: 0.01))

        // less
        XCTAssertTrue(p.isLess(than: 0.02))

        // negative
        XCTAssertFalse(p.isNegative())
        XCTAssertTrue(q.isNegative())

        // lte
        XCTAssertTrue(p.isLessThanOrEqualTo(0.01))
        XCTAssertTrue(p.isLessThanOrEqualTo(0.02))

        // order
        XCTAssertTrue(p.isTotallyOrdered(belowOrEqualTo: 0.01))
        XCTAssertTrue(p.isTotallyOrdered(belowOrEqualTo: 0.02))

        // <
        XCTAssertTrue(p < 0.02)

        // >
        XCTAssertTrue(p > 0.001)
    }

    func testFormattingWithDefaultScale() {
        let percentage: Percentage = 0.1

        XCTAssertEqual("10%", percentage.formatted())
    }

    func testFormattingWithNonZeroScale() {
        
        let percentage: Percentage = 0.1771
        
        XCTAssertEqual("17.71%", percentage.formatted(scale: 2))
    }

    func testFormattingRoundingUpWithZeroScale() {
        let percentage: Percentage = 0.1957

        XCTAssertEqual("20%", percentage.formatted(scale: 0))
    }

    func testFormattingRoundingDownWithZeroScale() {
        let percentage: Percentage = 0.1939

        XCTAssertEqual("19%", percentage.formatted(scale: 0))
    }
}
