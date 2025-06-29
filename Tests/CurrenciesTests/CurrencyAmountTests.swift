//
//  CurrencyAmountTests.swift
//  Currencies-iOS Tests
//
//  Created by Bo Gosmer on 29/01/2018.
//  Copyright © 2018 Ka-ching. All rights reserved.
//

import XCTest

@testable import Currencies

private struct CurrencyAmountWrapper: Codable {
    let amount: CurrencyAmount
}

final class CurrencyAmountTests: XCTestCase {
    func testCodable() {
        // this is tested indirectly through CurrencyAmountWrapper since currency code is just a string when serialized
        let currencyAmountJSON = "{\"amount\": 8.98}"
        let decoded = try? JSONDecoder()
            .decode(CurrencyAmountWrapper.self, from: currencyAmountJSON.data(using: .utf8)!)  // swiftlint:disable:this force_unwrapping
        XCTAssertNotNil(decoded)

        // Our new fancy clamping when decoding makes the internal decimal value very precise version of 8.98
        // which is not equal to Decimal(8.98). Hence this beautiful workaround through a string "8,98".
        XCTAssertEqual(decoded!.amount, CurrencyAmount(value: Decimal(string: "8.98")!))  //swiftlint:disable:this force_unwrapping

        let encoded = try? JSONEncoder().encode(CurrencyAmountWrapper(amount: CurrencyAmount(8.98)))
        XCTAssertNotNil(encoded)
    }

    func testArithmetic() {
        let tenPointOO1: CurrencyAmount = 10.001
        let twentyPoint002: CurrencyAmount = 20.002
        XCTAssertEqual(tenPointOO1 + tenPointOO1, twentyPoint002)
        XCTAssertEqual(tenPointOO1 - tenPointOO1, 0)
        XCTAssertEqual(tenPointOO1 * 10, 100.01)
        XCTAssertEqual(tenPointOO1 / 10, 1.0001)

        var amount = tenPointOO1
        amount += tenPointOO1
        XCTAssertEqual(amount, twentyPoint002)
        amount -= tenPointOO1
        XCTAssertEqual(amount, tenPointOO1)
        amount *= 2
        XCTAssertEqual(amount, twentyPoint002)
        amount /= 2
        XCTAssertEqual(amount, tenPointOO1)
    }

    func testHashable() {
        XCTAssertEqual(
            CurrencyAmount(integerLiteral: 10).hashValue,
            CurrencyAmount(integerLiteral: 10).hashValue
        )
        XCTAssertNotEqual(
            CurrencyAmount(integerLiteral: 10).hashValue,
            CurrencyAmount(integerLiteral: 20).hashValue
        )
    }

    func testAbsolute() {
        XCTAssertEqual(abs(CurrencyAmount(integerLiteral: -10)), CurrencyAmount(integerLiteral: 10))
    }

    func testNegate() {
        let zero = CurrencyAmount(integerLiteral: 0)
        var otherZero = zero
        otherZero.negate()
        XCTAssertEqual(zero, otherZero)
    }

    func testClampingOfManyDecimals() {
        let decimal = Decimal(
            _exponent: -16,
            _length: 4,
            _isNegative: 0,
            _isCompact: 0,
            _reserved: 0,
            _mantissa: (65023, 35303, 8964, 35527, 0, 0, 0, 0)
        )
        let amount = CurrencyAmount(value: decimal)

        XCTAssertEqual(amount, 1000)
    }
}
