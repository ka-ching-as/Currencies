//
//  Decimal_CurrencyAmount.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 04/01/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

extension Decimal {
    public var currencyAmount: CurrencyAmount {
        return CurrencyAmount(value: self)
    }
}
