//
//  CurrencyConversionTests.swift
//  Currencies-iOS Tests
//
//  Created by Bo Gosmer on 30/01/2018.
//  Copyright © 2018 Ka-ching. All rights reserved.
//

import XCTest

@testable import Currencies

final class CurrencyConversionTests: XCTestCase {
    let DKK = Currency(currencyCode: .DKK, denominations: [0.5], scale: 2)
    let EUR = Currency(currencyCode: .EUR, denominations: [0.01], scale: 2)
    let SEK = Currency(currencyCode: .SEK, denominations: [1], scale: 2)

    func testInit() {
        // default
        var service: CurrencyConversionService? = CurrencyConversionService()
        if let service = service {
            XCTAssertEqual(service.rates.count, 0)
            XCTAssertEqual(service.exchangeRateMargin, 1)
            XCTAssertEqual(service.currencies.count, 0)
        }

        // valid
        service = try? CurrencyConversionService(
            rates: [DKK.currencyCode: 7.5, EUR.currencyCode: 1],
            currencies: [DKK, EUR],
            exchangeRateMargin: 1
        )
        XCTAssertNotNil(service)

        // invalid 1
        service = try? CurrencyConversionService(
            rates: [DKK.currencyCode: 7.5, EUR.currencyCode: -1],
            currencies: [DKK, EUR],
            exchangeRateMargin: 1
        )
        XCTAssertNil(service)

        // invalid 2
        service = try? CurrencyConversionService(
            rates: [DKK.currencyCode: 7.5],
            currencies: [DKK, EUR],
            exchangeRateMargin: 1
        )
        XCTAssertNil(service)

        // invalid 3
        service = try? CurrencyConversionService(
            rates: [DKK.currencyCode: 7.5, EUR.currencyCode: 1],
            currencies: [DKK, EUR],
            exchangeRateMargin: 0.99
        )
        XCTAssertNil(service)
    }

    func testConversion() {
        let service: CurrencyConversionService! = try? CurrencyConversionService(
            rates: [DKK.currencyCode: 7.5, EUR.currencyCode: 1],
            currencies: [DKK, EUR],
            exchangeRateMargin: 1
        )  // swiftlint:disable:this force_unwrapping implicitly_unwrapped_optional
        XCTAssertNotNil(service)

        let convertedFromBase = service.convert(amount: 15, from: DKK, to: EUR)
        XCTAssertEqual(convertedFromBase, ForeignCurrencyAmount(value: 2, currency: EUR))

        let convertedToBase = service.convert(
            amount: ForeignCurrencyAmount(value: 2, currency: EUR),
            to: DKK
        )
        XCTAssertEqual(convertedToBase, CurrencyAmount(integerLiteral: 15))

        // TODO: test the fatal errors asserted in the convert methods, but that needs some exception handling. Fx: https://github.com/mattgallagher/CwlPreconditionTesting
    }

}
