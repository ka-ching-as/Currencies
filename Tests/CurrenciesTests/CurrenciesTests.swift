//
//  Currency.swift
//  CurrenciesTest
//
//  Created by Morten Ditlevsen on 4/1/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Currencies
import Foundation
import XCTest

extension Decimal {
    var doubleValue: Double {
        return Double.nan
    }
}

final class CurrenciesTests: XCTestCase {
    let DKK = Currency(currencyCode: .DKK, denominations: [0.5], scale: 2)

    override func setUp() {
        super.setUp()

        CurrencyAmount.locale = Locale(identifier: "da")
    }

    func testScales() {
        // 1 Jordanian Dinar can be represented as 1000 fils
        let JOD = Currency(currencyCode: .JOD, denominations: [0.001], scale: 3)
        let a: CurrencyAmount = 1234.5678

        // Value will be rounded to 3 decimals
        XCTAssertEqual(
            a.formatted(currency: JOD, showCurrencyCode: true),
            "1.234,568 JOD"
        )

        // Japanese YEN do not have any subdivisions, and as such their scale is 0
        let JPY = Currency(currencyCode: .JPY, denominations: [1], scale: 0)
        XCTAssertEqual(
            a.formatted(currency: JPY, showCurrencyCode: true),
            "1.235 JPY"
        )
    }

    func testSetLocale() {
        let a: CurrencyAmount = 1000.25
        CurrencyAmount.locale = Locale(identifier: "da")
        XCTAssertEqual(
            a.formatted(currency: DKK, showCurrencyCode: true),
            "1.000,25 DKK"
        )

        CurrencyAmount.locale = Locale(identifier: "en")
        XCTAssertEqual(
            a.formatted(currency: DKK, showCurrencyCode: true),
            "1,000.25 DKK"
        )
    }

    func testRounding() {
        let scaledCurrency = Currency(currencyCode: .DKK, denominations: [0.1], scale: 1)
        let input: [CurrencyAmount] = [1.46, 1.45, 1.44, -1.46, -1.45, -1.44]

        let positiveRoundResults: [CurrencyAmount] = [1.5, 1.5, 1.4, -1.5, -1.4, -1.4]
        let plainRoundResults: [CurrencyAmount] = [1.5, 1.5, 1.4, -1.5, -1.5, -1.4]
        let roundUpResults: [CurrencyAmount] = [1.5, 1.5, 1.5, -1.4, -1.4, -1.4]
        let roundDownResults: [CurrencyAmount] = [1.4, 1.4, 1.4, -1.5, -1.5, -1.5]

        for (input, expectedResult) in zip(input, positiveRoundResults) {
            XCTAssertEqual(
                input.rounding(mode: .positive, currency: scaledCurrency),
                expectedResult
            )
        }
        for (input, expectedResult) in zip(input, plainRoundResults) {
            XCTAssertEqual(input.rounding(mode: .plain, currency: scaledCurrency), expectedResult)
        }
        for (input, expectedResult) in zip(input, roundUpResults) {
            XCTAssertEqual(input.rounding(mode: .up, currency: scaledCurrency), expectedResult)
        }
        for (input, expectedResult) in zip(input, roundDownResults) {
            XCTAssertEqual(input.rounding(mode: .down, currency: scaledCurrency), expectedResult)
        }
    }

    func testSmallestDenominationRoundingDKK() {
        let input: [CurrencyAmount] = [1.26, 1.25, 1.24, -1.26, -1.25, -1.24]

        let positiveRoundResults: [CurrencyAmount] = [1.5, 1.5, 1.0, -1.5, -1.0, -1.0]
        let plainRoundResults: [CurrencyAmount] = [1.5, 1.5, 1.0, -1.5, -1.5, -1.0]
        let roundUpResults: [CurrencyAmount] = [1.5, 1.5, 1.5, -1.0, -1.0, -1.0]
        let roundDownResults: [CurrencyAmount] = [1.0, 1.0, 1.0, -1.5, -1.5, -1.5]

        for (input, expectedResult) in zip(input, positiveRoundResults) {
            XCTAssertEqual(
                input.roundingToSmallestDenomination(mode: .positive, currency: DKK),
                expectedResult
            )
        }
        for (input, expectedResult) in zip(input, plainRoundResults) {
            XCTAssertEqual(
                input.roundingToSmallestDenomination(mode: .plain, currency: DKK),
                expectedResult
            )
        }
        for (input, expectedResult) in zip(input, roundUpResults) {
            XCTAssertEqual(
                input.roundingToSmallestDenomination(mode: .up, currency: DKK),
                expectedResult
            )
        }
        for (input, expectedResult) in zip(input, roundDownResults) {
            XCTAssertEqual(
                input.roundingToSmallestDenomination(mode: .down, currency: DKK),
                expectedResult
            )
        }
    }

    func testSmallestDenominationRoundingJPY() {
        // Japanese YEN do not have any subdivisions, and as such their scale is 0
        let JPY = Currency(currencyCode: .JPY, denominations: [1], scale: 0)
        let input: [CurrencyAmount] = [1.6, 1.5, 1.4, -1.6, -1.5, -1.4]

        let positiveRoundResults: [CurrencyAmount] = [2, 2, 1, -2, -1, -1]
        let plainRoundResults: [CurrencyAmount] = [2, 2, 1, -2, -2, -1]
        let roundUpResults: [CurrencyAmount] = [2, 2, 2, -1, -1, -1]
        let roundDownResults: [CurrencyAmount] = [1, 1, 1, -2, -2, -2]

        for (input, expectedResult) in zip(input, positiveRoundResults) {
            XCTAssertEqual(
                input.roundingToSmallestDenomination(mode: .positive, currency: JPY),
                expectedResult
            )
        }
        for (input, expectedResult) in zip(input, plainRoundResults) {
            XCTAssertEqual(
                input.roundingToSmallestDenomination(mode: .plain, currency: JPY),
                expectedResult
            )
        }
        for (input, expectedResult) in zip(input, roundUpResults) {
            XCTAssertEqual(
                input.roundingToSmallestDenomination(mode: .up, currency: JPY),
                expectedResult
            )
        }
        for (input, expectedResult) in zip(input, roundDownResults) {
            XCTAssertEqual(
                input.roundingToSmallestDenomination(mode: .down, currency: JPY),
                expectedResult
            )
        }
    }

    func testSmallestDenominationRoundingJOD() {
        // 1 Jordanian Dinar can be represented as 1000 fils
        let JOD = Currency(currencyCode: .JOD, denominations: [0.001], scale: 3)

        // The floatLiteralConversion is not precise enough, so we represent the values as *10000
        // Hopefully some kind of 'DecimalLiteralConvertible' protocol will be added in the future.
        let input: [CurrencyAmount] = [10006, 10005, 10004, -10006, -10005, -10004]

        let positiveRoundResults: [CurrencyAmount] = [1001, 1001, 1000, -1001, -1000, -1000]
        let plainRoundResults: [CurrencyAmount] = [1001, 1001, 1000, -1001, -1001, -1000]
        let roundUpResults: [CurrencyAmount] = [1001, 1001, 1001, -1000, -1000, -1000]
        let roundDownResults: [CurrencyAmount] = [1000, 1000, 1000, -1001, -1001, -1001]

        for (input, expectedResult) in zip(input, positiveRoundResults) {
            let i = input / Decimal(10000)
            let e = expectedResult / Decimal(1000)
            XCTAssertEqual(i.roundingToSmallestDenomination(mode: .positive, currency: JOD), e)
        }
        for (input, expectedResult) in zip(input, plainRoundResults) {
            let i = input / Decimal(10000)
            let e = expectedResult / Decimal(1000)
            XCTAssertEqual(i.roundingToSmallestDenomination(mode: .plain, currency: JOD), e)
        }
        for (input, expectedResult) in zip(input, roundUpResults) {
            let i = input / Decimal(10000)
            let e = expectedResult / Decimal(1000)
            XCTAssertEqual(i.roundingToSmallestDenomination(mode: .up, currency: JOD), e)
        }
        for (input, expectedResult) in zip(input, roundDownResults) {
            let i = input / Decimal(10000)
            let e = expectedResult / Decimal(1000)
            XCTAssertEqual(i.roundingToSmallestDenomination(mode: .down, currency: JOD), e)
        }
    }

    func testRoundingForDecimals() {
        let input: [Decimal] = [1.46, 1.45, 1.44, -1.46, -1.45, -1.44]

        let positiveRoundResults: [Decimal] = [1.5, 1.5, 1.4, -1.5, -1.4, -1.4]
        let plainRoundResults: [Decimal] = [1.5, 1.5, 1.4, -1.5, -1.5, -1.4]
        let roundUpResults: [Decimal] = [1.5, 1.5, 1.5, -1.4, -1.4, -1.4]
        let roundDownResults: [Decimal] = [1.4, 1.4, 1.4, -1.5, -1.5, -1.5]

        for (input, expectedResult) in zip(input, positiveRoundResults) {
            XCTAssertEqual(input.rounding(toScale: 1, mode: .positive), expectedResult)
        }
        for (input, expectedResult) in zip(input, plainRoundResults) {
            XCTAssertEqual(input.rounding(toScale: 1, mode: .plain), expectedResult)
        }
        for (input, expectedResult) in zip(input, roundUpResults) {
            XCTAssertEqual(input.rounding(toScale: 1, mode: .up), expectedResult)
        }
        for (input, expectedResult) in zip(input, roundDownResults) {
            XCTAssertEqual(input.rounding(toScale: 1, mode: .down), expectedResult)
        }
    }

    func testPercentageParts() {
        // TODO: Add four test cases for this - with all the different signs
        let amounts: [CurrencyAmount] = [0, 100, -100]
        let pcts: [Percentage] = [0, 0.1, -0.1]

        for amount in amounts {
            for pct in pcts {
                let total = amount.adding(pct)
                let parts = total.percentageParts(with: pct)
                let joined = parts.baseAmount + parts.percentageAmount

                if amount != 0 {
                    XCTAssertEqual(parts.percentageAmount / parts.baseAmount, pct.value)
                }
                XCTAssertEqual(parts.baseAmount, amount)
                XCTAssertEqual(joined, total)
            }
        }
    }

    func testDescription() {
        let a: CurrencyAmount = 1
        let b: CurrencyAmount = 1_000
        let c: CurrencyAmount = 1_000_000
        let localeDA = Locale(identifier: "da")
        let localeEN = Locale(identifier: "en")

        // With two different locales
        XCTAssertEqual(
            a.formatted(currency: DKK, showCurrencyCode: true, fixedLocale: localeDA),
            "1,00 DKK"
        )
        XCTAssertEqual(
            a.formatted(currency: DKK, showCurrencyCode: true, fixedLocale: localeEN),
            "1.00 DKK"
        )

        // Without locales (testing global locale)
        CurrencyAmount.locale = localeEN
        XCTAssertEqual(a.formatted(currency: DKK, showCurrencyCode: true), "1.00 DKK")
        CurrencyAmount.locale = localeDA
        XCTAssertEqual(a.formatted(currency: DKK, showCurrencyCode: true), "1,00 DKK")

        // Without currency code
        XCTAssertEqual(a.formatted(currency: DKK), "1,00")

        // With formatting width
        XCTAssertEqual(a.formatted(currency: DKK, formatWidth: 10), "      1,00")
        XCTAssertEqual(b.formatted(currency: DKK, formatWidth: 10), "  1.000,00")
        // 'formatWidth' only pads, it never truncates.
        XCTAssertEqual(c.formatted(currency: DKK, formatWidth: 10), "1.000.000,00")
    }

    func testMutatingMath() {
        var a: CurrencyAmount = 3
        let b: CurrencyAmount = 4
        let c: Decimal = 2

        a.add(b)
        XCTAssertEqual(a, 7)

        a.subtract(b)
        XCTAssertEqual(a, 3)

        a.divide(by: c)
        XCTAssertEqual(a, 1.5)

        a.multiply(by: c)
        XCTAssertEqual(a, 3)

        a.negate()
        XCTAssertEqual(a, -3)
    }

    func testComparisons() {
        let a: CurrencyAmount = 1
        let b: CurrencyAmount = 2

        XCTAssertFalse(a.isEqual(to: b))
        XCTAssertTrue(a.isEqual(to: a))

        XCTAssertTrue(a.isLess(than: b))
        XCTAssertFalse(a.isLess(than: a))
        XCTAssertFalse(b.isLess(than: a))

        XCTAssertFalse(a.isNegative())
        XCTAssertTrue((0 - a).isNegative())

        XCTAssertTrue(a.isLessThanOrEqualTo(b))
        XCTAssertTrue(a.isLessThanOrEqualTo(a))
        XCTAssertFalse(b.isLessThanOrEqualTo(a))

        XCTAssertTrue(a.isTotallyOrdered(belowOrEqualTo: b))
    }

    func testOperatorOverloads() {
        let a: CurrencyAmount = 4
        let b: CurrencyAmount = 8
        let c: Decimal = 2

        XCTAssertEqual(a + b, 12)
        XCTAssertEqual(a - b, -4)
        XCTAssertEqual(b - a, 4)

        XCTAssertEqual(a * c, 8)
        XCTAssertEqual(c * a, 8)

        XCTAssertEqual(b / c, CurrencyAmount(integerLiteral: 4))
        XCTAssertEqual(b / a, Decimal(2))

        XCTAssertTrue(a < b)
        XCTAssertTrue(a <= b)
        XCTAssertFalse(a > b)
        XCTAssertFalse(a >= b)
    }

    func testNegateZero() {
        let a: CurrencyAmount = 0
        let b = -a
        XCTAssertEqual(a, b)
    }
    //FIXME
    //    func testExtensions() {
    //        let a: CurrencyAmount = 4
    //        let b: CurrencyAmount = 8
    //        let c: CurrencyAmount = -3
    //        let d: Decimal = 4
    //
    //        XCTAssertEqual(a.distance(to: b), -4)
    //        XCTAssertEqual(b.distance(to: a), 4)
    //
    //        XCTAssertEqual(a.advanced(by: 1), 5)
    //
    //        XCTAssertEqual(a.hashValue, CurrencyAmount(integerLiteral: 4).hashValue)
    //
    //        XCTAssertEqual(abs(c), 3)
    //
    //        XCTAssertEqual(d.currencyAmount, a)
    //    }
}

#if os(Linux)
extension CurrenciesTests {
    static var allTests: [(String, (CurrenciesTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample)
        ]
    }
}
#endif
