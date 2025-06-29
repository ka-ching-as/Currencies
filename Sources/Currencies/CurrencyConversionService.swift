//
//  CurrencyConversionService.swift
//  Currencies
//
//  Created by Morten Bek Ditlevsen on 07/04/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

public enum CurrencyConversionError: Error {
    case noBaseCurrency
    case noExchangeRate(Currency)
    case badExchangeRateMargin
    case exchangeRatesMustBePositive
}

// For the life time of the CurrencyConversionService, we don't allow changes to base currency, rates, available currencies or exchange rate margin
// This allows us to fail gracefully when manager is initialized - instead of during conversion
public class CurrencyConversionService {
    public let rates: [CurrencyCode: Decimal]
    public let exchangeRateMargin: Decimal
    public let currencies: [Currency]

    public init() {
        self.exchangeRateMargin = 1
        self.rates = [:]
        self.currencies = []
    }

    public init(
        rates: [CurrencyCode: Decimal],
        currencies: [Currency],
        exchangeRateMargin: Decimal
    ) throws {
        guard exchangeRateMargin >= 1 else {
            throw CurrencyConversionError.badExchangeRateMargin
        }

        for currency in currencies {
            guard rates[currency.currencyCode] != nil else {
                throw CurrencyConversionError.noExchangeRate(currency)
            }
        }
        for rate in rates.values {
            guard rate > 0 else {
                throw CurrencyConversionError.exchangeRatesMustBePositive
            }
        }

        self.exchangeRateMargin = exchangeRateMargin
        self.currencies = currencies
        self.rates = rates
    }

    public func convert(amount: ForeignCurrencyAmount, to currency: Currency) -> CurrencyAmount {
        guard let rate = rates[amount.currency.currencyCode] else {
            fatalError(
                "Currency amount MUST be in one of the currencies supplied by the CurrencyConversionService"
            )
        }
        guard let currencyRate = rates[currency.currencyCode] else {
            // Already checked - internal error
            fatalError("Missing exchange rate - internal error")
        }

        let value = (currencyRate * amount.value / (rate * exchangeRateMargin))
        return value.currencyAmount
    }

    public func convert(
        amount: CurrencyAmount,
        from baseCurrency: Currency,
        to currency: Currency
    ) -> ForeignCurrencyAmount {
        guard baseCurrency != currency else {
            fatalError("Programmer error: Trying to convert base currency to itself")
        }
        guard let rate = rates[currency.currencyCode] else {
            fatalError(
                "Currency amount MUST be in one of the currencies supplied by the CurrencyConversionService"
            )
        }
        guard let baseCurrencyRate = rates[baseCurrency.currencyCode] else {
            // Already checked - internal error
            fatalError("Missing exchange rate - internal error")
        }
        guard rate > 0 && baseCurrencyRate > 0 else {
            fatalError("Exchange rates cannot be 0 or less")
        }

        let value = (exchangeRateMargin * amount.value * rate / baseCurrencyRate)
        return ForeignCurrencyAmount(value: value, currency: currency)
    }
}
