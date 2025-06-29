//
//  CurrencyTests.swift
//  Currencies-iOS Tests
//
//  Created by Bo Gosmer on 30/01/2018.
//  Copyright © 2018 Ka-ching. All rights reserved.
//

import XCTest

@testable import Currencies

extension JSONDecoder {
    static func create() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension JSONEncoder {
    static func create() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

final class CurrencyTests: XCTestCase {
    func testEquatable() {
        XCTAssertEqual(
            Currency(currencyCode: .DKK, denominations: [0.5], scale: 2),
            Currency(currencyCode: .DKK, denominations: [0.5], scale: 2)
        )

        let currency1 = Currency(abbreviation: "DKK", denominations: [0.01], scale: 2)
        var currency2 = Currency(abbreviation: "DKK", denominations: [0.01], scale: 2)
        XCTAssertEqual(currency1, currency2)

        // predefined and string abbreviation currencies are not equal even if they share iso code
        currency2 = Currency(currencyCode: .DKK, denominations: [0.01], scale: 2)
        XCTAssertNotEqual(currency1, currency2)

        // equality doesn't depend on denominations and/or scale
        currency2 = Currency(abbreviation: "DKK", denominations: [1], scale: 1)
        XCTAssertEqual(currency1, currency2)

        // negative
        currency2 = Currency(currencyCode: .SEK, denominations: [0.1], scale: 2)
        XCTAssertNotEqual(currency1, currency2)
    }

    func testCodable() {
        let decodable = "{\"denominations\":[0.5],\"currency_code\":\"DKK\",\"scale\":2}"
        let decoded = try? JSONDecoder.create()
            .decode(Currency.self, from: decodable.data(using: .utf8)!)  // swiftlint:disable:this force_unwrapping
        XCTAssertNotNil(decoded)
        let encodable = Currency(currencyCode: .DKK, denominations: [0.5], scale: 2)
        let encoded = try? JSONEncoder.create().encode(encodable)
        XCTAssertNotNil(encoded)
    }
}
