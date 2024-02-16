//
//  Currency.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation

public enum CurrencyEnum: String, CustomStringConvertible, Codable, CurrencyType {
    
    public var name: String {
        switch self {
        case .AED:return "UAE Dirham"
        case .AFN:return "Afghani"
        case .ALL:return "Lek"
        case .AMD:return "Armenian Dram"
        case .ANG:return "Netherlands Antillean Guilder"
        case .AOA:return "Kwanza"
        case .ARS:return "Argentine Peso"
        case .AUD:return "Australian Dollar"
        case .AWG:return "Aruban Florin"
        case .AZN:return "Azerbaijan Manat"
        case .BAM:return "Convertible Mark"
        case .BBD:return "Barbados Dollar"
        case .BDT:return "Taka"
        case .BGN:return "Bulgarian Lev"
        case .BHD:return "Bahraini Dinar"
        case .BIF:return "Burundi Franc"
        case .BMD:return "Bermudian Dollar"
        case .BND:return "Brunei Dollar"
        case .BOB:return "Boliviano"
        case .BOV:return "Mvdol"
        case .BRL:return "Brazilian Real"
        case .BSD:return "Bahamian Dollar"
        case .BTN:return "Ngultrum"
        case .BWP:return "Pula"
        case .BYN:return "Belarusian Ruble"
        case .BZD:return "Belize Dollar"
        case .CAD:return "Canadian Dollar"
        case .CDF:return "Congolese Franc"
        case .CHE:return "WIR Euro"
        case .CHF:return "Swiss Franc"
        case .CHW:return "WIR Franc"
        case .CLF:return "Unidad de Fomento"
        case .CLP:return "Chilean Peso"
        case .CNY:return "Yuan Renminbi"
        case .COP:return "Colombian Peso"
        case .COU:return "Unidad de Valor Real"
        case .CRC:return "Costa Rican Colon"
        case .CUC:return "Peso Convertible"
        case .CUP:return "Cuban Peso"
        case .CVE:return "Cabo Verde Escudo"
        case .CZK:return "Czech Koruna"
        case .DJF:return "Djibouti Franc"
        case .DKK:return "Danish Krone"
        case .DOP:return "Dominican Peso"
        case .DZD:return "Algerian Dinar"
        case .EGP:return "Egyptian Pound"
        case .ERN:return "Nakfa"
        case .ETB:return "Ethiopian Birr"
        case .EUR:return "Euro"
        case .FJD:return "Fiji Dollar"
        case .FKP:return "Falkland Islands Pound"
        case .GBP:return "Pound Sterling"
        case .GEL:return "Lari"
        case .GHS:return "Ghana Cedi"
        case .GIP:return "Gibraltar Pound"
        case .GMD:return "Dalasi"
        case .GNF:return "Guinean Franc"
        case .GTQ:return "Quetzal"
        case .GYD:return "Guyana Dollar"
        case .HKD:return "Hong Kong Dollar"
        case .HNL:return "Lempira"
        case .HRK:return "Kuna"
        case .HTG:return "Gourde"
        case .HUF:return "Forint"
        case .IDR:return "Rupiah"
        case .ILS:return "New Israeli Sheqel"
        case .INR:return "Indian Rupee"
        case .IQD:return "Iraqi Dinar"
        case .IRR:return "Iranian Rial"
        case .ISK:return "Iceland Krona"
        case .JMD:return "Jamaican Dollar"
        case .JOD:return "Jordanian Dinar"
        case .JPY:return "Yen"
        case .KES:return "Kenyan Shilling"
        case .KGS:return "Som"
        case .KHR:return "Riel"
        case .KMF:return "Comorian Franc"
        case .KPW:return "North Korean Won"
        case .KRW:return "Won"
        case .KWD:return "Kuwaiti Dinar"
        case .KYD:return "Cayman Islands Dollar"
        case .KZT:return "Tenge"
        case .LAK:return "Lao Kip"
        case .LBP:return "Lebanese Pound"
        case .LKR:return "Sri Lanka Rupee"
        case .LRD:return "Liberian Dollar"
        case .LSL:return "Loti"
        case .LYD:return "Libyan Dinar"
        case .MAD:return "Moroccan Dirham"
        case .MDL:return "Moldovan Leu"
        case .MGA:return "Malagasy Ariary"
        case .MKD:return "Denar"
        case .MMK:return "Kyat"
        case .MNT:return "Tugrik"
        case .MOP:return "Pataca"
        case .MRU:return "Ouguiya"
        case .MUR:return "Mauritius Rupee"
        case .MVR:return "Rufiyaa"
        case .MWK:return "Malawi Kwacha"
        case .MXN:return "Mexican Peso"
        case .MXV:return "Mexican Unidad de Inversion (UDI)"
        case .MYR:return "Malaysian Ringgit"
        case .MZN:return "Mozambique Metical"
        case .NAD:return "Namibia Dollar"
        case .NGN:return "Naira"
        case .NIO:return "Cordoba Oro"
        case .NOK:return "Norwegian Krone"
        case .NPR:return "Nepalese Rupee"
        case .NZD:return "New Zealand Dollar"
        case .OMR:return "Rial Omani"
        case .PAB:return "Balboa"
        case .PEN:return "Sol"
        case .PGK:return "Kina"
        case .PHP:return "Philippine Piso"
        case .PKR:return "Pakistan Rupee"
        case .PLN:return "Zloty"
        case .PYG:return "Guarani"
        case .QAR:return "Qatari Rial"
        case .RON:return "Romanian Leu"
        case .RSD:return "Serbian Dinar"
        case .RUB:return "Russian Ruble"
        case .RWF:return "Rwanda Franc"
        case .SAR:return "Saudi Riyal"
        case .SBD:return "Solomon Islands Dollar"
        case .SCR:return "Seychelles Rupee"
        case .SDG:return "Sudanese Pound"
        case .SEK:return "Swedish Krona"
        case .SGD:return "Singapore Dollar"
        case .SHP:return "Saint Helena Pound"
        case .SLL:return "Leone"
        case .SOS:return "Somali Shilling"
        case .SRD:return "Surinam Dollar"
        case .SSP:return "South Sudanese Pound"
        case .STN:return "Dobra"
        case .SVC:return "El Salvador Colon"
        case .SYP:return "Syrian Pound"
        case .SZL:return "Lilangeni"
        case .THB:return "Baht"
        case .TJS:return "Somoni"
        case .TMT:return "Turkmenistan New Manat"
        case .TND:return "Tunisian Dinar"
        case .TOP:return "Pa’anga"
        case .TRY:return "Turkish Lira"
        case .TTD:return "Trinidad and Tobago Dollar"
        case .TWD:return "New Taiwan Dollar"
        case .TZS:return "Tanzanian Shilling"
        case .UAH:return "Hryvnia"
        case .UGX:return "Uganda Shilling"
        case .USD:return "US Dollar"
        case .UYI:return "Uruguay Peso en Unidades Indexadas (UI)"
        case .UYU:return "Peso Uruguayo"
        case .UZS:return "Uzbekistan Sum"
        case .VEF:return "Bolívar"
        case .VND:return "Dong"
        case .VUV:return "Vatu"
        case .WST:return "Tala"
        case .XCD:return "East Caribbean Dollar"
        case .YER:return "Yemeni Rial"
        case .ZAR:return "Rand"
        case .ZMW:return "Zambian Kwacha"
        case .ZWL:return "Zimbabwe Dollar"
        }

    }
    
    public var minorUnit: Int {
        switch self {
        
        case .AED:return 2
        case .AFN:return 2
        case .ALL:return 2
        case .BHD:return 3
        case .BIF:return 0
        case .CLF:return 4
        case .CLP:return 0
        case .DJF:return 0
        case .GNF:return 0
        case .IQD:return 3
        case .ISK:return 0
        case .JOD:return 3
        case .JPY:return 0
        case .KMF:return 0
        case .KRW:return 0
        case .KWD:return 3
        case .LYD:return 3
        case .PYG:return 0
        case .RWF:return 0
        case .TND:return 3
        case .UYI:return 0
        case .VND:return 0
        case .VUV:return 0
        default: return 2
        }
    }
    
    public var description: String {
        return self.rawValue
    }
        case AED
        case AFN
        case ALL
        case AMD
        case ANG
        case AOA
        case ARS
        case AUD
        case AWG
        case AZN
        case BAM
        case BBD
        case BDT
        case BGN
        case BHD
        case BIF
        case BMD
        case BND
        case BOB
        case BOV
        case BRL
        case BSD
        case BTN
        case BWP
        case BYN
        case BZD
        case CAD
        case CDF
        case CHE
        case CHF
        case CHW
        case CLF
        case CLP
        case CNY
        case COP
        case COU
        case CRC
        case CUC
        case CUP
        case CVE
        case CZK
        case DJF
        case DKK
        case DOP
        case DZD
        case EGP
        case ERN
        case ETB
        case EUR
        case FJD
        case FKP
        case GBP
        case GEL
        case GHS
        case GIP
        case GMD
        case GNF
        case GTQ
        case GYD
        case HKD
        case HNL
        case HRK
        case HTG
        case HUF
        case IDR
        case ILS
        case INR
        case IQD
        case IRR
        case ISK
        case JMD
        case JOD
        case JPY
        case KES
        case KGS
        case KHR
        case KMF
        case KPW
        case KRW
        case KWD
        case KYD
        case KZT
        case LAK
        case LBP
        case LKR
        case LRD
        case LSL
        case LYD
        case MAD
        case MDL
        case MGA
        case MKD
        case MMK
        case MNT
        case MOP
        case MRU
        case MUR
        case MVR
        case MWK
        case MXN
        case MXV
        case MYR
        case MZN
        case NAD
        case NGN
        case NIO
        case NOK
        case NPR
        case NZD
        case OMR
        case PAB
        case PEN
        case PGK
        case PHP
        case PKR
        case PLN
        case PYG
        case QAR
        case RON
        case RSD
        case RUB
        case RWF
        case SAR
        case SBD
        case SCR
        case SDG
        case SEK
        case SGD
        case SHP
        case SLL
        case SOS
        case SRD
        case SSP
        case STN
        case SVC
        case SYP
        case SZL
        case THB
        case TJS
        case TMT
        case TND
        case TOP
        case TRY
        case TTD
        case TWD
        case TZS
        case UAH
        case UGX
        case USD
        case UYI
        case UYU
        case UZS
        case VEF
        case VND
        case VUV
        case WST
        case XCD
        case YER
        case ZAR
        case ZMW
        case ZWL
}

/// A monetary unit.
public protocol CurrencyType {

    /// The name of the currency.
    var name: String { get }

    /**
        The number of decimal places used to express
        any minor units for the currency.

        For example, the US Dollar (USD)
        has a minor unit (cents)
        equal to 1/100 of a dollar,
        and therefore takes 2 decimal places.
        The Japanese Yen (JPY)
        doesn't have a minor unit,
        and therefore takes 0 decimal places.
    */
    var minorUnit: Int { get }
}
