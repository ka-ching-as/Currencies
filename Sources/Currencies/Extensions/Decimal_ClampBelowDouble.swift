//
//  Decimal_ClampBelowDouble.swift
//  Currencies-iOS
//
//  Created by Bo Gosmer on 22/04/2020.
//  Copyright © 2020 Ka-ching. All rights reserved.
//

import Foundation

// This is used to clamp the Decimal value below what can be safely represented
// when reading and writing values which internally is represented by a Double.
// We got in trouble with 999.9999999999999488 so we are clamping to 7 decimals
// which should leave us with adequate headroom with regards to the  scale of
// current currencies.
extension Decimal {
    func clampedBelowDouble() -> Decimal {
        return rounding(toScale: 7, mode: .plain)
    }
}
