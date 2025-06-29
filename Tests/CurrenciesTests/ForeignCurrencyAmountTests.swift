//
//  ForeignCurrencyAmountTests.swift
//  Currencies-iOS Tests
//
//  Created by Bo Gosmer on 29/01/2018.
//  Copyright © 2018 Ka-ching. All rights reserved.
//

import XCTest

@testable import Currencies

final class ForeignCurrencyAmountTests: XCTestCase {

    func testInit() {
        let foreign = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        )
        XCTAssertEqual(foreign.value, 10)
        XCTAssertEqual(
            foreign.currency,
            Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        )
    }

    func testEquatable() {
        // same value and equal currency - predefined
        XCTAssertEqual(
            ForeignCurrencyAmount(
                value: 1,
                currency: Currency(currencyCode: .SEK, denominations: [1], scale: 2)
            ),
            ForeignCurrencyAmount(
                value: 1,
                currency: Currency(currencyCode: .SEK, denominations: [1], scale: 2)
            )
        )
        // same value and equal currency - string literal
        let foreign1 = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        )
        var foreign2 = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        )
        XCTAssertEqual(foreign1, foreign2)
        // currency code affect equality
        foreign2 = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "DKK", denominations: [0.01], scale: 2)
        )
        XCTAssertNotEqual(foreign1, foreign2)
        // denominations don't affect equality
        foreign2 = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [1], scale: 1)
        )
        XCTAssertEqual(foreign1, foreign2)
    }

    func testHashable() {
        let foreign1 = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        )
        var foreign2 = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        )
        XCTAssertEqual(foreign1.hashValue, foreign2.hashValue)
        // denomination and scale doesn't affect hashvalue
        foreign2 = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [0.1], scale: 1)
        )
        XCTAssertEqual(foreign1, foreign2)
        // currency code affects hasvalue
        foreign2 = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "DKK", denominations: [0.1], scale: 1)
        )
        XCTAssertNotEqual(foreign1, foreign2)
        // value affects hashvalue
        foreign2 = ForeignCurrencyAmount(
            value: 20,
            currency: Currency(abbreviation: "EUR", denominations: [0.1], scale: 1)
        )
        XCTAssertNotEqual(foreign1, foreign2)
    }

    func testFormatted() {
        CurrencyAmount.locale = Locale(identifier: "us")
        let currency = Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        let foreign = ForeignCurrencyAmount(value: 10, currency: currency)
        XCTAssertEqual(foreign.formatted(currency: currency, showCurrencyCode: true), "10.00 EUR")

        CurrencyAmount.locale = .current
    }

    func testCurrencyAmountConvenienceMethod() {
        let foreign = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        )
        XCTAssertEqual(foreign.currencyAmount(with: 10), foreign)
    }

    func testPlaygroundQuickLook() {
        CurrencyAmount.locale = Locale(identifier: "us")
        let foreign = ForeignCurrencyAmount(
            value: 10,
            currency: Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        )
        if let s = foreign.playgroundDescription as? String {
            XCTAssertEqual(s, "10.00")
        } else {
            XCTFail("Couldn't get playground quicklook from foreign curre3ncy amount")
        }
        CurrencyAmount.locale = .current
    }

    func testRounding() {
        let c = Currency(abbreviation: "EUR", denominations: [0.01], scale: 2)
        let point01 = ForeignCurrencyAmount(value: 0.01, currency: c)
        var point005 = ForeignCurrencyAmount(value: 0.005, currency: c)
        let zero = ForeignCurrencyAmount(value: 0, currency: c)

        XCTAssertEqual(point005.rounding(mode: .down), zero)
        point005.round(mode: .up)
        XCTAssertEqual(point005, point01)

        point005 = ForeignCurrencyAmount(value: 0.005, currency: c)
        XCTAssertEqual(point005.roundingToSmallestDenomination(mode: .down), zero)
        point005.roundToSmallestDenomination(mode: .up)
        XCTAssertEqual(point005, point01)
    }
}
