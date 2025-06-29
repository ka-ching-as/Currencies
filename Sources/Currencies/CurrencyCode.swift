//
//  CurrencyCode.swift
//  Currencies
//
//  Created by Morten Ditlevsen on 4/1/2017.
//  Copyright © 2017 Ka-ching. All rights reserved.
//

import Foundation

public enum CurrencyCode: RawRepresentable, Codable, Hashable, Sendable {
    case custom(abbreviation: String)
    case predefined(PredefinedCurrencyCode)

    public var abbreviation: String {
        switch self {
        case .predefined(let predefined):
            return predefined.rawValue
        case .custom(let abbreviation):
            return abbreviation
        }
    }

    public var name: String {
        switch self {
        case .predefined(let predefined):
            return predefined.name
        case .custom(let abbreviation):
            return abbreviation
        }
    }

    public init(
        rawValue: String
    ) {
        if let predefined = PredefinedCurrencyCode(rawValue: rawValue) {
            self = .predefined(predefined)
        } else {
            self = .custom(abbreviation: rawValue)
        }
    }

    public init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        if let predefined = PredefinedCurrencyCode(rawValue: rawValue) {
            self = .predefined(predefined)
        } else {
            self = .custom(abbreviation: rawValue)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    public var rawValue: String { return abbreviation }

    // TODO: You could define all predefined currency codes like this
    public static let DKK: CurrencyCode = .predefined(.DKK)
}

extension CurrencyCode: Equatable {
    public static func == (lhs: CurrencyCode, rhs: CurrencyCode) -> Bool {
        switch (lhs, rhs) {
        case (.predefined(let lhsp), .predefined(let rhsp)):
            return lhsp == rhsp
        case (.custom(let lhsa), .custom(let rhsa)):
            return lhsa == rhsa
        default:
            return false
        }
    }
}

/// The CurrencyCode enum defines ISO 4217
/// Table downloaded as a spreadsheet from http://www.currency-iso.org/en/home/tables/table-a1.html
//swiftlint:disable:next type_body_length
public enum PredefinedCurrencyCode: String, Sendable {
    case
        AED,  // UAE Dirham
        AFN,  // Afghani
        ALL,  // Lek
        AMD,  // Armenian Dram
        ANG,  // Netherlands Antillean Guilder
        AOA,  // Kwanza
        ARS,  // Argentine Peso
        AUD,  // Australian Dollar
        AWG,  // Aruban Florin
        AZN,  // Azerbaijanian Manat
        BAM,  // Convertible Mark
        BBD,  // Barbados Dollar
        BDT,  // Taka
        BGN,  // Bulgarian Lev
        BHD,  // Bahraini Dinar
        BIF,  // Burundi Franc
        BMD,  // Bermudian Dollar
        BND,  // Brunei Dollar
        BOB,  // Boliviano
        BOV,  // Mvdol
        BRL,  // Brazilian Real
        BSD,  // Bahamian Dollar
        BTN,  // Ngultrum
        BWP,  // Pula
        BYN,  // Belarusian Ruble
        BYR,  // Belarusian Ruble
        BZD,  // Belize Dollar
        CAD,  // Canadian Dollar
        CDF,  // Congolese Franc
        CHE,  // WIR Euro
        CHF,  // Swiss Franc
        CHW,  // WIR Franc
        CLF,  // Unidad de Fomento
        CLP,  // Chilean Peso
        CNY,  // Yuan Renminbi
        COP,  // Colombian Peso
        COU,  // Unidad de Valor Real
        CRC,  // Costa Rican Colon
        CUC,  // Peso Convertible
        CUP,  // Cuban Peso
        CVE,  // Cabo Verde Escudo
        CZK,  // Czech Koruna
        DJF,  // Djibouti Franc
        DKK,  // Danish Krone
        DOP,  // Dominican Peso
        DZD,  // Algerian Dinar
        EGP,  // Egyptian Pound
        ERN,  // Nakfa
        ETB,  // Ethiopian Birr
        EUR,  // Euro
        FJD,  // Fiji Dollar
        FKP,  // Falkland Islands Pound
        GBP,  // Pound Sterling
        GEL,  // Lari
        GHS,  // Ghana Cedi
        GIP,  // Gibraltar Pound
        GMD,  // Dalasi
        GNF,  // Guinea Franc
        GTQ,  // Quetzal
        GYD,  // Guyana Dollar
        HKD,  // Hong Kong Dollar
        HNL,  // Lempira
        HRK,  // Kuna
        HTG,  // Gourde
        HUF,  // Forint
        IDR,  // Rupiah
        ILS,  // New Israeli Sheqel
        INR,  // Indian Rupee
        IQD,  // Iraqi Dinar
        IRR,  // Iranian Rial
        ISK,  // Iceland Krona
        JMD,  // Jamaican Dollar
        JOD,  // Jordanian Dinar
        JPY,  // Yen
        KES,  // Kenyan Shilling
        KGS,  // Som
        KHR,  // Riel
        KMF,  // Comoro Franc
        KPW,  // North Korean Won
        KRW,  // Won
        KWD,  // Kuwaiti Dinar
        KYD,  // Cayman Islands Dollar
        KZT,  // Tenge
        LAK,  // Kip
        LBP,  // Lebanese Pound
        LKR,  // Sri Lanka Rupee
        LRD,  // Liberian Dollar
        LSL,  // Loti
        LYD,  // Libyan Dinar
        MAD,  // Moroccan Dirham
        MDL,  // Moldovan Leu
        MGA,  // Malagasy Ariary
        MKD,  // Denar
        MMK,  // Kyat
        MNT,  // Tugrik
        MOP,  // Pataca
        MRO,  // Ouguiya
        MUR,  // Mauritius Rupee
        MVR,  // Rufiyaa
        MWK,  // Malawi Kwacha
        MXN,  // Mexican Peso
        MXV,  // Mexican Unidad de Inversion (UDI)
        MYR,  // Malaysian Ringgit
        MZN,  // Mozambique Metical
        NAD,  // Namibia Dollar
        NGN,  // Naira
        NIO,  // Cordoba Oro
        NOK,  // Norwegian Krone
        NPR,  // Nepalese Rupee
        NZD,  // New Zealand Dollar
        OMR,  // Rial Omani
        PAB,  // Balboa
        PEN,  // Sol
        PGK,  // Kina
        PHP,  // Philippine Peso
        PKR,  // Pakistan Rupee
        PLN,  // Zloty
        PYG,  // Guarani
        QAR,  // Qatari Rial
        RON,  // Romanian Leu
        RSD,  // Serbian Dinar
        RUB,  // Russian Ruble
        RWF,  // Rwanda Franc
        SAR,  // Saudi Riyal
        SBD,  // Solomon Islands Dollar
        SCR,  // Seychelles Rupee
        SDG,  // Sudanese Pound
        SEK,  // Swedish Krona
        SGD,  // Singapore Dollar
        SHP,  // Saint Helena Pound
        SLL,  // Leone
        SOS,  // Somali Shilling
        SRD,  // Surinam Dollar
        SSP,  // South Sudanese Pound
        STD,  // Dobra
        SVC,  // El Salvador Colon
        SYP,  // Syrian Pound
        SZL,  // Lilangeni
        THB,  // Baht
        TJS,  // Somoni
        TMT,  // Turkmenistan New Manat
        TND,  // Tunisian Dinar
        TOP,  // Pa’anga
        TRY,  // Turkish Lira
        TTD,  // Trinidad and Tobago Dollar
        TWD,  // New Taiwan Dollar
        TZS,  // Tanzanian Shilling
        UAH,  // Hryvnia
        UGX,  // Uganda Shilling
        USD,  // US Dollar
        USN,  // US Dollar (Next day)
        UYI,  // Uruguay Peso en Unidades Indexadas (URUIURUI)
        UYU,  // Peso Uruguayo
        UZS,  // Uzbekistan Sum
        VEF,  // Bolívar
        VND,  // Dong
        VUV,  // Vatu
        WST,  // Tala
        XAF,  // CFA Franc BEAC
        XAG,  // Silver
        XAU,  // Gold
        XBA,  // Bond Markets Unit European Composite Unit (EURCO)
        XBB,  // Bond Markets Unit European Monetary Unit (E.M.U.-6)
        XBC,  // Bond Markets Unit European Unit of Account 9 (E.U.A.-9)
        XBD,  // Bond Markets Unit European Unit of Account 17 (E.U.A.-17)
        XCD,  // East Caribbean Dollar
        XDR,  // SDR (Special Drawing Right)
        XOF,  // CFA Franc BCEAO
        XPD,  // Palladium
        XPF,  // CFP Franc
        XPT,  // Platinum
        XSU,  // Sucre
        XTS,  // Codes specifically reserved for testing purposes
        XUA,  // ADB Unit of Account
        XXX,  // The codes assigned for transactions where no currency is involved
        YER,  // Yemeni Rial
        ZAR,  // Rand
        ZMW,  // Zambian Kwacha
        ZWL  // Zimbabwe Dollar

    public var name: String {
        switch self {
        case .AED: return "UAE Dirham"
        case .AFN: return "Afghani"
        case .ALL: return "Lek"
        case .AMD: return "Armenian Dram"
        case .ANG: return "Netherlands Antillean Guilder"
        case .AOA: return "Kwanza"
        case .ARS: return "Argentine Peso"
        case .AUD: return "Australian Dollar"
        case .AWG: return "Aruban Florin"
        case .AZN: return "Azerbaijanian Manat"
        case .BAM: return "Convertible Mark"
        case .BBD: return "Barbados Dollar"
        case .BDT: return "Taka"
        case .BGN: return "Bulgarian Lev"
        case .BHD: return "Bahraini Dinar"
        case .BIF: return "Burundi Franc"
        case .BMD: return "Bermudian Dollar"
        case .BND: return "Brunei Dollar"
        case .BOB: return "Boliviano"
        case .BOV: return "Mvdol"
        case .BRL: return "Brazilian Real"
        case .BSD: return "Bahamian Dollar"
        case .BTN: return "Ngultrum"
        case .BWP: return "Pula"
        case .BYN: return "Belarusian Ruble"
        case .BYR: return "Belarusian Ruble"
        case .BZD: return "Belize Dollar"
        case .CAD: return "Canadian Dollar"
        case .CDF: return "Congolese Franc"
        case .CHE: return "WIR Euro"
        case .CHF: return "Swiss Franc"
        case .CHW: return "WIR Franc"
        case .CLF: return "Unidad de Fomento"
        case .CLP: return "Chilean Peso"
        case .CNY: return "Yuan Renminbi"
        case .COP: return "Colombian Peso"
        case .COU: return "Unidad de Valor Real"
        case .CRC: return "Costa Rican Colon"
        case .CUC: return "Peso Convertible"
        case .CUP: return "Cuban Peso"
        case .CVE: return "Cabo Verde Escudo"
        case .CZK: return "Czech Koruna"
        case .DJF: return "Djibouti Franc"
        case .DKK: return "Danish Krone"
        case .DOP: return "Dominican Peso"
        case .DZD: return "Algerian Dinar"
        case .EGP: return "Egyptian Pound"
        case .ERN: return "Nakfa"
        case .ETB: return "Ethiopian Birr"
        case .EUR: return "Euro"
        case .FJD: return "Fiji Dollar"
        case .FKP: return "Falkland Islands Pound"
        case .GBP: return "Pound Sterling"
        case .GEL: return "Lari"
        case .GHS: return "Ghana Cedi"
        case .GIP: return "Gibraltar Pound"
        case .GMD: return "Dalasi"
        case .GNF: return "Guinea Franc"
        case .GTQ: return "Quetzal"
        case .GYD: return "Guyana Dollar"
        case .HKD: return "Hong Kong Dollar"
        case .HNL: return "Lempira"
        case .HRK: return "Kuna"
        case .HTG: return "Gourde"
        case .HUF: return "Forint"
        case .IDR: return "Rupiah"
        case .ILS: return "New Israeli Sheqel"
        case .INR: return "Indian Rupee"
        case .IQD: return "Iraqi Dinar"
        case .IRR: return "Iranian Rial"
        case .ISK: return "Iceland Krona"
        case .JMD: return "Jamaican Dollar"
        case .JOD: return "Jordanian Dinar"
        case .JPY: return "Yen"
        case .KES: return "Kenyan Shilling"
        case .KGS: return "Som"
        case .KHR: return "Riel"
        case .KMF: return "Comoro Franc"
        case .KPW: return "North Korean Won"
        case .KRW: return "Won"
        case .KWD: return "Kuwaiti Dinar"
        case .KYD: return "Cayman Islands Dollar"
        case .KZT: return "Tenge"
        case .LAK: return "Kip"
        case .LBP: return "Lebanese Pound"
        case .LKR: return "Sri Lanka Rupee"
        case .LRD: return "Liberian Dollar"
        case .LSL: return "Loti"
        case .LYD: return "Libyan Dinar"
        case .MAD: return "Moroccan Dirham"
        case .MDL: return "Moldovan Leu"
        case .MGA: return "Malagasy Ariary"
        case .MKD: return "Denar"
        case .MMK: return "Kyat"
        case .MNT: return "Tugrik"
        case .MOP: return "Pataca"
        case .MRO: return "Ouguiya"
        case .MUR: return "Mauritius Rupee"
        case .MVR: return "Rufiyaa"
        case .MWK: return "Malawi Kwacha"
        case .MXN: return "Mexican Peso"
        case .MXV: return "Mexican Unidad de Inversion (UDI)"
        case .MYR: return "Malaysian Ringgit"
        case .MZN: return "Mozambique Metical"
        case .NAD: return "Namibia Dollar"
        case .NGN: return "Naira"
        case .NIO: return "Cordoba Oro"
        case .NOK: return "Norwegian Krone"
        case .NPR: return "Nepalese Rupee"
        case .NZD: return "New Zealand Dollar"
        case .OMR: return "Rial Omani"
        case .PAB: return "Balboa"
        case .PEN: return "Sol"
        case .PGK: return "Kina"
        case .PHP: return "Philippine Peso"
        case .PKR: return "Pakistan Rupee"
        case .PLN: return "Zloty"
        case .PYG: return "Guarani"
        case .QAR: return "Qatari Rial"
        case .RON: return "Romanian Leu"
        case .RSD: return "Serbian Dinar"
        case .RUB: return "Russian Ruble"
        case .RWF: return "Rwanda Franc"
        case .SAR: return "Saudi Riyal"
        case .SBD: return "Solomon Islands Dollar"
        case .SCR: return "Seychelles Rupee"
        case .SDG: return "Sudanese Pound"
        case .SEK: return "Swedish Krona"
        case .SGD: return "Singapore Dollar"
        case .SHP: return "Saint Helena Pound"
        case .SLL: return "Leone"
        case .SOS: return "Somali Shilling"
        case .SRD: return "Surinam Dollar"
        case .SSP: return "South Sudanese Pound"
        case .STD: return "Dobra"
        case .SVC: return "El Salvador Colon"
        case .SYP: return "Syrian Pound"
        case .SZL: return "Lilangeni"
        case .THB: return "Baht"
        case .TJS: return "Somoni"
        case .TMT: return "Turkmenistan New Manat"
        case .TND: return "Tunisian Dinar"
        case .TOP: return "Pa’anga"
        case .TRY: return "Turkish Lira"
        case .TTD: return "Trinidad and Tobago Dollar"
        case .TWD: return "New Taiwan Dollar"
        case .TZS: return "Tanzanian Shilling"
        case .UAH: return "Hryvnia"
        case .UGX: return "Uganda Shilling"
        case .USD: return "US Dollar"
        case .USN: return "US Dollar (Next day)"
        case .UYI: return "Uruguay Peso en Unidades Indexadas (URUIURUI)"
        case .UYU: return "Peso Uruguayo"
        case .UZS: return "Uzbekistan Sum"
        case .VEF: return "Bolívar"
        case .VND: return "Dong"
        case .VUV: return "Vatu"
        case .WST: return "Tala"
        case .XAF: return "CFA Franc BEAC"
        case .XAG: return "Silver"
        case .XAU: return "Gold"
        case .XBA: return "Bond Markets Unit European Composite Unit (EURCO)"
        case .XBB: return "Bond Markets Unit European Monetary Unit (E.M.U.-6)"
        case .XBC: return "Bond Markets Unit European Unit of Account 9 (E.U.A.-9)"
        case .XBD: return "Bond Markets Unit European Unit of Account 17 (E.U.A.-17)"
        case .XCD: return "East Caribbean Dollar"
        case .XDR: return "SDR (Special Drawing Right)"
        case .XOF: return "CFA Franc BCEAO"
        case .XPD: return "Palladium"
        case .XPF: return "CFP Franc"
        case .XPT: return "Platinum"
        case .XSU: return "Sucre"
        case .XTS: return "Codes specifically reserved for testing purposes"
        case .XUA: return "ADB Unit of Account"
        case .XXX: return "The codes assigned for transactions where no currency is involved"
        case .YER: return "Yemeni Rial"
        case .ZAR: return "Rand"
        case .ZMW: return "Zambian Kwacha"
        case .ZWL: return "Zimbabwe Dollar"
        }
    }
}
