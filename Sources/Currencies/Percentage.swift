//
//  Percentage.swift
//  Currencies
//
//  Created by Morten Bek Ditlevsen on 14/06/2018.
//  Copyright © 2018 Ka-ching. All rights reserved.
//

import Foundation

private let formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.groupingSize = 3
    f.usesGroupingSeparator = true
    f.minimumIntegerDigits = 1
    f.paddingCharacter = " "
    f.locale = Locale.current
    return f
}()

/// The ´Percentage´ struct just wraps a Decimal value and contains
/// all the same methods and protocol conformances that the Decimal type also
/// provides.
public struct Percentage: Codable, Equatable, Hashable, Sendable {

    public init(
        value: Decimal
    ) {
        let clamped = value.clampedBelowDouble()
        self.value = clamped
    }

    public static var locale: Locale {
        get { return formatter.locale }
        set { formatter.locale = newValue }
    }

    public init(
        from decoder: Decoder
    ) throws {
        let value = try decoder.singleValueContainer().decode(Decimal.self)
        let clamped = value.clampedBelowDouble()
        self.value = clamped
    }
    
    public func encode(to encoder: Encoder) throws {
        let clamped = value.clampedBelowDouble()
        var container = encoder.singleValueContainer()
        try container.encode(clamped)
    }

    /// The representation of the amount value
    public var value: Decimal
    
    public func description(scale: Int = 0) -> String {
        precondition(scale >= 0, "Negative scale unsupported")
        let digits = max(0, Int(scale))
        if formatter.minimumFractionDigits != digits {
            formatter.minimumFractionDigits = digits
        }
        if formatter.maximumFractionDigits != digits {
            formatter.maximumFractionDigits = digits
        }
        let formatted =
            formatter.string(from: NSDecimalNumber(decimal: value * 100)) ?? "\(value * 100)"
        return "\(formatted)%"
    }

    /// Mutating addition
    ///
    /// - Parameter other: value to add to self
    public mutating func add(_ other: Percentage) {
        value += other.value
    }

    /// Mutating subtraction
    ///
    /// - Parameter other: value to subtract from self
    public mutating func subtract(_ other: Percentage) {
        value -= other.value
    }

    /// Mutating multiplication
    ///
    /// - Parameter other: decimal value to multiply by
    public mutating func multiply(by other: Decimal) {
        value *= other
    }

    /// Mutating division
    ///
    /// - Parameter other: decimal value to divide by
    public mutating func divide(by other: Decimal) {
        value /= other
    }

    /// Mutating negation
    public mutating func negate() {
        value.negate()
    }

    public func isEqual(to other: Percentage) -> Bool {
        value.isEqual(to: other.value)
    }

    public func isLess(than other: Percentage) -> Bool {
        value.isLess(than: other.value)
    }

    public func isNegative() -> Bool {
        isLess(than: 0)
    }

    public func isLessThanOrEqualTo(_ other: Percentage) -> Bool {
        value.isLessThanOrEqualTo(other.value)
    }

    public func isTotallyOrdered(belowOrEqualTo other: Percentage) -> Bool {
        value.isTotallyOrdered(belowOrEqualTo: other.value)
    }

    public mutating func round(toScale scale: Int, mode: Decimal.ExtendedRoundingMode)  {
        var value = self.value
        value.round(toScale: scale, mode: mode)
        self = Percentage(value: value)
    }
    
    public func rounding(toScale scale: Int, mode: Decimal.ExtendedRoundingMode) -> Percentage {
        Percentage(value: value.rounding(toScale: scale, mode: mode))
    }

    public static func + (lhs: Percentage, rhs: Percentage) -> Percentage {
        Percentage(value: lhs.value + rhs.value)
    }

    public static func += (lhs: inout Percentage, rhs: Percentage) {
        lhs.value += rhs.value
    }

    public static func -= (lhs: inout Percentage, rhs: Percentage) {
        lhs.value -= rhs.value
    }

    public static func *= (lhs: inout Percentage, rhs: Decimal) {
        lhs.value = lhs.value * rhs  //swiftlint:disable:this shorthand_operator
    }

    public static func /= (lhs: inout Percentage, rhs: Decimal) {
        lhs.value = lhs.value / rhs  //swiftlint:disable:this shorthand_operator
    }

    public static func - (lhs: Percentage, rhs: Percentage) -> Percentage {
        Percentage(value: lhs.value - rhs.value)
    }

    public static func / (lhs: Percentage, rhs: Decimal) -> Percentage {
        Percentage(value: lhs.value / rhs)
    }

    public static func / (lhs: Percentage, rhs: Percentage) -> Decimal {
        lhs.value / rhs.value
    }

    public static func * (lhs: Percentage, rhs: Decimal) -> Percentage {
        Percentage(value: lhs.value * rhs)
    }

    public static func * (lhs: Decimal, rhs: Percentage) -> Percentage {
        Percentage(value: rhs.value * lhs)
    }

    prefix public static func - (operand: Percentage) -> Percentage {
        Percentage(value: 0 - operand.value)
    }

    public static func * (lhs: Percentage, rhs: Int) -> Percentage {
        Percentage(value: lhs.value * Decimal(rhs))
    }

    public static func * (lhs: Int, rhs: Percentage) -> Percentage {
        Percentage(value: rhs.value * Decimal(lhs))
    }

    public static func * (lhs: Percentage, rhs: CurrencyAmount) -> CurrencyAmount {
        CurrencyAmount(value: lhs.value * rhs.value)
    }

    public static func / (lhs: CurrencyAmount, rhs: Percentage) -> CurrencyAmount {
        CurrencyAmount(value: lhs.value / rhs.value)
    }

    public static func * (lhs: CurrencyAmount, rhs: Percentage) -> CurrencyAmount {
        CurrencyAmount(value: lhs.value * rhs.value)
    }
}

// MARK: -
extension Percentage {
    // MARK: Formatting
    public func formatted(scale: Int = 0) -> String {
        precondition(scale >= 0, "Negative scale unsupported")
        let digits = max(0, Int(scale))
        if formatter.minimumFractionDigits != digits {
            formatter.minimumFractionDigits = digits
        }
        if formatter.maximumFractionDigits != digits {
            formatter.maximumFractionDigits = digits
        }
        let formatted =
            formatter.string(from: NSDecimalNumber(decimal: value * 100)) ?? "\(value * 100)"
        return "\(formatted)%"
    }

    // MARK: Formatting
    public func formatted(minScale: Int = 0, maxScale: Int) -> String {
        precondition(minScale >= 0, "Negative scale unsupported")
        precondition(maxScale >= minScale, "maxScale must be greater than or equal to minScale")
        var scale = minScale
        for candidate in minScale...maxScale {
            scale = candidate
            if self.value.rounding(toScale: candidate + 2, mode: .plain) == self.value {
                break
            }
        }
        return self.formatted(scale: scale)
    }

    public func formatAutoscaled() -> String {
        formatted(maxScale: 10)
    }
}

// MARK: -
extension Percentage: CustomPlaygroundDisplayConvertible {
    // MARK: CustomPlaygroundDisplayConvertible
    public var playgroundDescription: Any {
        return description
    }
}

// MARK: -
extension Percentage: CustomStringConvertible {
    // MARK: CustomStringConvertible
    public var description: String {
        return description()
    }
}

// MARK: -
extension Percentage: CustomDebugStringConvertible {
    // MARK: CustomDebugStringConvertible
    public var debugDescription: String {
        return description
    }
}

// MARK: -
extension Percentage: Comparable {
    // MARK: Comparable
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: Percentage, rhs: Percentage) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: -
extension Percentage: ExpressibleByFloatLiteral {
    // MARK: ExpressibleByFloatLiteral
    /// Creates an instance initialized to the specified floating-point value.
    public init(
        floatLiteral value: Double
    ) {
        self.value = Decimal(value)
    }
}

// MARK: -
extension Percentage: ExpressibleByIntegerLiteral {
    // MARK: ExpressibleByIntegerLiteral
    /// Create an instance initialized to `value`.
    public init(
        integerLiteral value: Int
    ) {
        self.value = Decimal(value)
    }
}

extension Percentage: AdditiveArithmetic {
    public static let zero: Percentage = Percentage(value: 0)
}

/// Returns the absolute value of `x`.
public func abs(_ x: Percentage) -> Percentage {
    return Percentage(value: Swift.abs(x.value))
}
