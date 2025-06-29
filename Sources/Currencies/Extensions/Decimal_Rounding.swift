//
//  Decimal_Rounding.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 05/01/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

extension Decimal {
    /// Defines a rounding mode that includes 'positive' rounding
    ///
    /// - plain: See Decimal.RoundingMode
    /// - up: See Decimal.RoundingMode
    /// - down: See Decimal.RoundingMode
    /// - negative: Using the functionality in positive to generate a rounding in the negative direction (multiplying by -1)
    /// - positive: Rounds to the closest possible return value; when caught halfway between two numbers, round in positive direction;
    /// In other words - it always rounds in the positive direction on halfway rounds. This means that the 'sign'
    /// of the number decides the rounding direction.
    ///
    /// Example - rounding to base 1 using .positive rounding
    /// ```
    ///  1.46 ->  1.5
    ///  1.45 ->  1.5
    ///  1.44 ->  1.4
    /// -1.46 -> -1.5
    /// -1.45 -> -1.4
    /// -1.44 -> -1.4
    /// ```
    /// For positive values, this is the same as 'plain' rounding
    public enum ExtendedRoundingMode {
        case plain, up, down, positive, negative
    }

    /// Basically a wrapper around NSDecimalRound - with the added functionality of
    /// the extra rounding mode.
    ///
    /// - Parameters:
    ///   - scale: The scale to round to - as used by NSDecimalNumber rounding
    ///   - mode: The mode to use for rounding
    public mutating func round(toScale scale: Int, mode: ExtendedRoundingMode) {
        var number = self

        let decimalRoundingMode: Decimal.RoundingMode
        switch mode {
        case .up:
            decimalRoundingMode = .up
        case .down:
            decimalRoundingMode = .down
        case .plain:
            decimalRoundingMode = .plain
        case .positive:
            guard isLess(than: 0) else {
                NSDecimalRound(&self, &number, scale, .plain)
                return
            }

            // We do this by offsetting the value by an amount big enough to make it positive
            // Then we round using .plain and subtract the offset again.
            // A 'big enough' offset can be found by rounding the absolute value up
            var offset = abs(self)
            var offsetResult: Decimal = 0
            NSDecimalRound(&offsetResult, &offset, scale, .up)

            var positiveValue = offsetResult + self
            var result: Decimal = 0
            NSDecimalRound(&result, &positiveValue, scale, .plain)
            self = result - offsetResult
            return
        case .negative:
            var flipped = self * -1
            flipped.round(toScale: scale, mode: .positive)
            self = flipped * -1
            return
        }

        NSDecimalRound(&self, &number, scale, decimalRoundingMode)
    }

    /// Non-mutating version of `round`
    ///
    /// - Parameters:
    ///   - scale: The scale to round to - as used by NSDecimalNumber rounding
    ///   - mode: The mode to use for rounding
    /// - Returns: The rounded value
    public func rounding(toScale scale: Int, mode: ExtendedRoundingMode) -> Decimal {
        var value = self
        value.round(toScale: scale, mode: mode)
        return value
    }
}
