//
//  ForeignCurrency.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 05/01/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

public struct ForeignCurrencyAmount: SharedCurrencyAmount, Equatable, Hashable {
    /// The representation of the amount value
    public var value: Decimal

    public let currency: Currency

    public func currencyAmount(with decimal: Decimal) -> ForeignCurrencyAmount {
        return ForeignCurrencyAmount(value: decimal, currency: currency)
    }

    public init(
        value: Decimal,
        currency: Currency
    ) {
        self.value = value
        self.currency = currency
    }
}

extension ForeignCurrencyAmount: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension ForeignCurrencyAmount: CustomStringConvertible {
    public var description: String {
        return formatted(currency: currency)
    }
}

extension ForeignCurrencyAmount: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}
