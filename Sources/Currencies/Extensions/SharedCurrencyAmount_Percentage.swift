//
//  CurrencyAmount_PercentageMath.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 05/01/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

extension SharedCurrencyAmount {
    /// Increments the amount by the specified percentage
    ///
    /// - Parameter percentage: The percentage of the original value to add. E.g. var value = 100; value.add(percentage: 0.1) gives 110.
    public mutating func add(_ percentage: Percentage) {
        value = value * (percentage.value + 1)
    }

    /// Returns a CurrencyAmount with the specified percentage added to the receiver.
    ///
    /// - Parameter percentage: The percentage of the original value to add. E.g. var value = 100; value.add(percentage: 0.1) gives 110.
    /// - Returns: The incremented value
    public func adding(_ percentage: Percentage) -> Self {
        var mutating = self
        mutating.add(percentage)
        return mutating
    }

    /// Considers a value to consist of a base and an added percentage of that base.
    ///
    /// - Parameter percentage: The percentage from which the base and added percentage should be calculated
    /// - Returns: A tuple containing the base amount and added percentage. The two values always adds up to be equal to the receiver.
    public func percentageParts(
        with percentage: Percentage
    ) -> (baseAmount: Self, percentageAmount: Self) {
        let baseAmount = value / (percentage.value + 1)
        let percentageAmount = value - baseAmount
        return (
            baseAmount: currencyAmount(with: baseAmount),
            percentageAmount: currencyAmount(with: percentageAmount)
        )
    }
}
