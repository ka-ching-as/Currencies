//
//  CurrencyCodeTests.swift
//  Currencies-iOS Tests
//
//  Created by Bo Gosmer on 29/01/2018.
//  Copyright © 2018 Ka-ching. All rights reserved.
//

import XCTest

@testable import Currencies

private struct CurrencyCodeWrapper: Codable {
    let code: CurrencyCode
}

final class CurrencyCodeTests: XCTestCase {

    func testInit() {
        // predefined
        let code = CurrencyCode(rawValue: "DKK")
        XCTAssertNotNil(code)
        // custom
        let custom = CurrencyCode(rawValue: "ZZZ")
        XCTAssertNotNil(custom)
    }

    func testCodableNotPossibleSinceItsJustAFragment() {
        // this is tested indirectly through CurrencyCodeWrapper since currency code is just a string when serialized
        let currencyCodeJSON = "{\"code\": \"DKK\"}"
        let decoded = try? JSONDecoder()
            .decode(CurrencyCodeWrapper.self, from: currencyCodeJSON.data(using: .utf8)!)  // swiftlint:disable:this force_unwrapping
        XCTAssertNotNil(decoded)

        let encoded = try? JSONEncoder().encode(CurrencyCodeWrapper(code: CurrencyCode.DKK))
        XCTAssertNotNil(encoded)
    }

    func testAbrreviation() {
        XCTAssertEqual(CurrencyCode.DKK.abbreviation, "DKK")
        XCTAssertEqual(CurrencyCode(rawValue: "ZZZ").abbreviation, "ZZZ")
    }

    func testName() {
        XCTAssertEqual(CurrencyCode.DKK.name, "Danish Krone")
        XCTAssertEqual(CurrencyCode(rawValue: "ZZZ").name, "ZZZ")
    }

    func testRawValue() {
        XCTAssertEqual(CurrencyCode.DKK.rawValue, "DKK")
    }

    func testEquatable() {
        XCTAssertEqual(CurrencyCode.DKK, CurrencyCode.DKK)
        XCTAssertEqual(CurrencyCode(rawValue: "ZZZ"), CurrencyCode(rawValue: "ZZZ"))
        XCTAssertNotEqual(CurrencyCode.DKK, CurrencyCode(rawValue: "EUR"))
    }

    func testHashable() {
        XCTAssertEqual(CurrencyCode.DKK.hashValue, CurrencyCode.DKK.hashValue)
        XCTAssertEqual(
            CurrencyCode(rawValue: "ZZZ").hashValue,
            CurrencyCode(rawValue: "ZZZ").hashValue
        )
        XCTAssertNotEqual(CurrencyCode.DKK.hashValue, CurrencyCode(rawValue: "EUR").hashValue)
    }

    func testNames() {
        let abbreviations = [
            "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD",
            "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BOV", "BRL", "BSD", "BTN", "BWP",
            "BYN", "BYR", "BZD", "CAD", "CDF", "CHE", "CHF", "CHW", "CLF", "CLP", "CNY", "COP",
            "COU", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN",
            "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD",
            "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "INR", "IQD", "IRR", "ISK", "JMD",
            "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK",
            "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP",
            "MRO", "MUR", "MVR", "MWK", "MXN", "MXV", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK",
            "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON",
            "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS",
            "SRD", "SSP", "STD", "SVC", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY",
            "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "USN", "UYI", "UYU", "UZS", "VEF", "VND",
            "VUV", "WST", "XAF", "XAG", "XAU", "XBA", "XBB", "XBC", "XBD", "XCD", "XDR", "XOF",
            "XPD", "XPF", "XPT", "XSU", "XTS", "XUA", "XXX", "YER", "ZAR", "ZMW", "ZWL",
        ]
        for abbreviation in abbreviations {
            let code = CurrencyCode(rawValue: abbreviation)
            XCTAssertNotNil(code.name)
        }
    }

}
