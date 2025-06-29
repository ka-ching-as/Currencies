//
//  Currency.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 4/1/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

/// The Currency type describes a currency by an ISO 4217 currency code, a list of denominations and a scale representing the amount of decimals a currency should be displayed with.
public struct Currency: Codable, Sendable {

    /// The ISO 4217 code for the currency
    public let currencyCode: CurrencyCode

    /// An ordered list of denominations that can be used for payment in the currency. For instance the currency DKK has the 50 øre coin, 1, 2, 5, 10 and 20 DKK coins and 50, 100, 200, 500 amd 1000 DKK bills. So the denominations for DKK would be: [0.50, 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000]
    public let denominations: [Decimal]

    /// Returns the smallest currency denomination. This can be used for stuff like rounding to cash-payable amounts.
    public var smallestDenomination: Decimal? {
        return denominations.first
    }

    /// Defines the 'scale' of the currency. The format is similar to what is used in the NSDecimalNumber concept of 'scale' - namely that it represents the amount of decimals. This means that a scale of 2 is relevant for most currencies (representing the 100 cents in a dollar, or the 100 øre in a Danish krone), but some currencies have a scale of 3. Negative scales could be imagined too - if 1000 were the smallest denomination then the scale could be -3.
    /// Note that while one might think that the scale could be determined from the smallest denomination, this is not always the case. In Norway, for instance, the smallest denomination is 1 NOK, but this is just the smallest cash unit - øre also exists in Norway, so the scale for NOK is 2 and not 0.
    public let scale: Int

    /// Public initializer for a currency
    ///
    /// - Parameters:
    ///   - currencyCode: The ISO 4217 currency code as defined by the CurrencyCode enum.
    ///   - denominations: The currency denominations available in the specified currency.
    ///   - scale: The scale of precision of the currency.

    public init(
        abbreviation: String,
        denominations: [Decimal],
        scale: Int
    ) {
        self.init(
            currencyCode: CurrencyCode.custom(abbreviation: abbreviation),
            denominations: denominations,
            scale: scale
        )
    }

    public init(
        currencyCode: PredefinedCurrencyCode,
        denominations: [Decimal],
        scale: Int
    ) {
        self.init(
            currencyCode: CurrencyCode.predefined(currencyCode),
            denominations: denominations,
            scale: scale
        )
    }

    private init(
        currencyCode: CurrencyCode,
        denominations: [Decimal],
        scale: Int
    ) {
        self.currencyCode = currencyCode
        self.denominations = denominations.sorted()
        self.scale = scale
    }

    public static let none = Currency(currencyCode: .XXX, denominations: [], scale: 0)
}

extension Currency: Hashable {
    public func hash(into hasher: inout Hasher) {
        currencyCode.hash(into: &hasher)
    }
}

extension Currency: Equatable {
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.currencyCode == rhs.currencyCode
    }
}
