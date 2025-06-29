//
//  SharedCurrencyAmount.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 05/01/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

private let sharedFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.groupingSize = 3
    f.usesGroupingSeparator = true
    f.minimumIntegerDigits = 1
    f.paddingCharacter = " "
    return f
}()

/// This protocol only exists in order to provide common implementations of rounding, percentage calculations and formatting
public protocol SharedCurrencyAmount: Sendable {
    var value: Decimal { get set }

    func currencyAmount(with amount: Decimal) -> Self
}

extension SharedCurrencyAmount {
    static var formatter: NumberFormatter {
        return sharedFormatter
    }
}

extension SharedCurrencyAmount {
    public func formatted(
        currency: Currency,
        showCurrencyCode: Bool = false,
        formatWidth: Int? = nil,
        fixedScale: Int? = nil,
        fixedLocale: Locale? = nil
    ) -> String {
        let scale = fixedScale ?? currency.scale
        let formatter = CurrencyAmount.formatter
        let locale = fixedLocale ?? CurrencyAmount.locale

        if formatter.locale != locale {
            formatter.locale = locale
        }
        let digits = max(0, Int(scale))
        if formatter.minimumFractionDigits != digits {
            formatter.minimumFractionDigits = digits
        }
        if formatter.maximumFractionDigits != digits {
            formatter.maximumFractionDigits = digits
        }

        if let formatWidth = formatWidth {
            if formatter.formatWidth != formatWidth {
                formatter.formatWidth = formatWidth
            }
            if formatter.paddingPosition != .beforePrefix {
                formatter.paddingPosition = .beforePrefix
            }
        } else {
            if formatter.formatWidth != 0 {
                formatter.formatWidth = 0
            }
        }

        // Use positive/negative suffix to add currency code since this will be counted as part of the
        // formatting width.
        let suffix: String = showCurrencyCode ? " \(currency.currencyCode.abbreviation)" : ""
        if formatter.positiveSuffix != suffix {
            formatter.positiveSuffix = suffix
        }
        if formatter.negativeSuffix != suffix {
            formatter.negativeSuffix = suffix
        }
        let amountString =
            formatter.string(from: NSDecimalNumber(decimal: value)) ?? value.description
        return amountString
    }
}
