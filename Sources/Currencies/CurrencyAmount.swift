//
//  Currency.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 4/1/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation
import os

/// The ´CurrencyAmount´ struct currently just wraps a Decimal value and contains
/// all the same methods and protocol conformances that the Decimal type also
/// provides.
public struct CurrencyAmount: SharedCurrencyAmount, Codable, Equatable, Hashable, Sendable {

    public init(
        value: Decimal
    ) {
        let clamped = value.clampedBelowDouble()

        self.value = clamped
    }

    public init(
        from decoder: Decoder
    ) throws {
        let value = try decoder.singleValueContainer().decode(Decimal.self)
        let clamped = value.clampedBelowDouble()

        self.value = clamped
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let clamped = value.clampedBelowDouble()

        try container.encode(clamped)
    }


    // TODO: From iOS 18 we can use Mutex rather than OSAllocatedUnfairLock
    private static let _locale = OSAllocatedUnfairLock(initialState: Locale.current)
    
    /// Locale to use for generic formatting
    public static var locale: Locale {
        get {
            _locale.withLock { $0 }
        }
        set {
            _locale.withLock {
                $0 = newValue
            }
        }
    }
    
    /// The representation of the amount value
    public var value: Decimal

    public func currencyAmount(with amount: Decimal) -> CurrencyAmount {
        return amount.currencyAmount
    }

    /// Mutating addition
    ///
    /// - Parameter other: value to add to self
    public mutating func add(_ other: CurrencyAmount) {
        value += other.value
    }

    /// Mutating subtraction
    ///
    /// - Parameter other: value to subtract from self
    public mutating func subtract(_ other: CurrencyAmount) {
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

    public func isEqual(to other: CurrencyAmount) -> Bool {
        return value.isEqual(to: other.value)
    }

    public func isLess(than other: CurrencyAmount) -> Bool {
        return value.isLess(than: other.value)
    }

    public func isNegative() -> Bool {
        return isLess(than: 0)
    }

    public func isLessThanOrEqualTo(_ other: CurrencyAmount) -> Bool {
        return value.isLessThanOrEqualTo(other.value)
    }

    public func isTotallyOrdered(belowOrEqualTo other: CurrencyAmount) -> Bool {
        return value.isTotallyOrdered(belowOrEqualTo: other.value)
    }

    public static func + (lhs: CurrencyAmount, rhs: CurrencyAmount) -> CurrencyAmount {
        return CurrencyAmount(value: lhs.value + rhs.value)
    }

    public static func += (lhs: inout CurrencyAmount, rhs: CurrencyAmount) {
        lhs.value += rhs.value
    }

    public static func -= (lhs: inout CurrencyAmount, rhs: CurrencyAmount) {
        lhs.value -= rhs.value
    }

    public static func *= (lhs: inout CurrencyAmount, rhs: Decimal) {
        lhs.value = lhs.value * rhs  //swiftlint:disable:this shorthand_operator
    }

    public static func /= (lhs: inout CurrencyAmount, rhs: Decimal) {
        lhs.value = lhs.value / rhs  //swiftlint:disable:this shorthand_operator
    }

    public static func - (lhs: CurrencyAmount, rhs: CurrencyAmount) -> CurrencyAmount {
        return CurrencyAmount(value: lhs.value - rhs.value)
    }

    public static func / (lhs: CurrencyAmount, rhs: Decimal) -> CurrencyAmount {
        return CurrencyAmount(value: lhs.value / rhs)
    }

    public static func / (lhs: CurrencyAmount, rhs: CurrencyAmount) -> Decimal {
        return lhs.value / rhs.value
    }

    // TODO: Add Int versions of all the current CurrencyAmount vs Decimal mults (as well as *= / /=)
    public static func * (lhs: CurrencyAmount, rhs: Decimal) -> CurrencyAmount {
        return CurrencyAmount(value: lhs.value * rhs)
    }

    public static func * (lhs: Decimal, rhs: CurrencyAmount) -> CurrencyAmount {
        return CurrencyAmount(value: rhs.value * lhs)
    }

    prefix public static func - (operand: CurrencyAmount) -> CurrencyAmount {
        return CurrencyAmount(value: 0 - operand.value)
    }
}

// MARK: -
extension CurrencyAmount {
    // MARK: Int
    public static func * (lhs: CurrencyAmount, rhs: Int) -> CurrencyAmount {
        return CurrencyAmount(value: lhs.value * Decimal(rhs))
    }

    public static func * (lhs: Int, rhs: CurrencyAmount) -> CurrencyAmount {
        return CurrencyAmount(value: Decimal(lhs) * rhs.value)
    }

    public static func *= (lhs: inout CurrencyAmount, rhs: Int) {
        lhs = lhs * rhs  //swiftlint:disable:this shorthand_operator
    }

    public static func / (lhs: CurrencyAmount, rhs: Int) -> CurrencyAmount {
        return CurrencyAmount(value: lhs.value / Decimal(rhs))
    }

    public static func /= (lhs: inout CurrencyAmount, rhs: Int) {
        lhs = lhs / rhs  //swiftlint:disable:this shorthand_operator
    }
}

extension CurrencyAmount: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension CurrencyAmount: CustomStringConvertible {
    public var description: String {
        return formatted(currency: .none)
    }
}

extension CurrencyAmount: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}

extension CurrencyAmount: Comparable {
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
    public static func < (lhs: CurrencyAmount, rhs: CurrencyAmount) -> Bool {
        return lhs.value < rhs.value
    }
}

extension CurrencyAmount: ExpressibleByFloatLiteral {
    /// Creates an instance initialized to the specified floating-point value.
    public init(
        floatLiteral value: Double
    ) {
        self.value = Decimal(value)
    }
}

extension CurrencyAmount: ExpressibleByIntegerLiteral {
    /// Create an instance initialized to `value`.
    public init(
        integerLiteral value: Int
    ) {
        self.value = Decimal(value)
    }
}

extension CurrencyAmount: AdditiveArithmetic {
    public static let zero: CurrencyAmount = CurrencyAmount(value: 0)
}

/// Returns the absolute value of `x`.
public func abs(_ x: CurrencyAmount) -> CurrencyAmount {
    return CurrencyAmount(value: Swift.abs(x.value))
}
