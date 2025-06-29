//
//  CurrencyAmount_Rounding.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 05/01/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

extension SharedCurrencyAmount {
    public func rounding(mode: Decimal.ExtendedRoundingMode, currency: Currency) -> Self {
        var value = self
        value.round(mode: mode, currency: currency)
        return value
    }

    public mutating func round(mode: Decimal.ExtendedRoundingMode, currency: Currency) {
        value.round(toScale: currency.scale, mode: mode)
    }

    public func roundingToSmallestDenomination(
        mode: Decimal.ExtendedRoundingMode,
        currency: Currency
    ) -> Self {
        var value = self
        value.roundToSmallestDenomination(mode: mode, currency: currency)
        return value
    }

    public mutating func roundToSmallestDenomination(
        mode: Decimal.ExtendedRoundingMode,
        currency: Currency
    ) {
        let smallestDenomination = currency.smallestDenomination ?? 1
        var scaledValue = value / smallestDenomination
        scaledValue.round(toScale: 0, mode: mode)
        value = scaledValue * smallestDenomination
    }
}

extension ForeignCurrencyAmount {
    public func rounding(mode: Decimal.ExtendedRoundingMode) -> ForeignCurrencyAmount {
        return rounding(mode: mode, currency: currency)
    }

    public mutating func round(mode: Decimal.ExtendedRoundingMode) {
        round(mode: mode, currency: currency)
    }

    public func roundingToSmallestDenomination(
        mode: Decimal.ExtendedRoundingMode
    ) -> ForeignCurrencyAmount {
        return roundingToSmallestDenomination(mode: mode, currency: currency)
    }

    public mutating func roundToSmallestDenomination(mode: Decimal.ExtendedRoundingMode) {
        roundToSmallestDenomination(mode: mode, currency: currency)
    }
}
