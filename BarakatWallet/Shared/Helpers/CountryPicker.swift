//
//  CountryPicker.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation

public class CountryPicker {
    
    public struct Country: Codable {
        public let countryName: String
        public let countryCode: String
        public let countryPhoneCode: String
        public let countryFullCode: String
        
        public init(countryName: String, countryCode: String, countryPhoneCode: String, countryFullCode: String) {
            self.countryName = countryName
            self.countryCode = countryCode
            self.countryPhoneCode = countryPhoneCode
            self.countryFullCode = countryFullCode
        }
    }
    
    public static func getAllCountry(language: String) -> [Country] {
        var country: [Country] = []
        if language.lowercased() == "en" {
            for info in self.data {
                country.append(Country(countryName: info["en"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!))
            }
        } else if language.lowercased() == "ru" {
            for info in self.data {
                country.append(Country(countryName: info["ru"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!))
            }
        } else {
            for info in self.data {
                country.append(Country(countryName: info["en"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!))
            }
        }
        return country
    }
    
//    static func emojiFlag(countryCode: String) -> String {
//        var string = ""
//        var country = countryCode.uppercased()
//        for uS in country.unicodeScalars {
//            string = String(UnicodeScalar(127397 + uS.value)!)
//        }
//        return string
//    }
    
    public static func flag(country: String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    public static func getCountry(code: String, language: String) -> Country? {
        if language.lowercased() == "en" {
            for info in self.data {
                if info["code"] == code {
                    return Country(countryName: info["en"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        } else if language.lowercased() == "ru" {
            for info in self.data {
                if info["code"] == code {
                    return Country(countryName: info["ru"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        } else {
            for info in self.data {
                if info["code"] == code {
                    return Country(countryName: info["en"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        }
        return nil
    }
    
    public static func getCountry(dialCode: String, language: String) -> Country? {
        if language.lowercased() == "en" {
            for info in self.data {
                if info["dial_code"] == dialCode {
                    return Country(countryName: info["en"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        } else if language.lowercased() == "ru" {
            for info in self.data {
                if info["dial_code"] == dialCode {
                    return Country(countryName: info["ru"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        } else {
            for info in self.data {
                if info["dial_code"] == dialCode {
                    return Country(countryName: info["en"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        }
        return nil
    }
    
    public static func getCurrentCountry(ISO: String, language: String) -> Country? {
        if language.lowercased() == "en" {
            for info in self.data {
                if info["code"] ==  ISO {
                    return Country(countryName: info["en"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        } else if language.lowercased() == "ru" {
            for info in self.data {
                if info["code"] ==  ISO {
                    return Country(countryName: info["ru"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        } else {
            for info in self.data {
                if info["code"] ==  ISO {
                    return Country(countryName: info["en"]!, countryCode: info["code"]!, countryPhoneCode: info["dial_code"]!, countryFullCode: info["code_full"]!)
                }
            }
        }
        return nil
    }
    
    static let data = [
        [
            "en": "Afghanistan",
            "ru": "Afghanistan",
            "dial_code": "+93",
            "code": "AF",
            "code_full": "AFG"
        ],
        [
            "en": "Aland Islands",
            "ru": "Aland Islands",
            "dial_code": "+358",
            "code": "AX",
            "code_full": "ALA"
        ],
        [
            "en": "Albania",
            "ru": "Albania",
            "dial_code": "+355",
            "code": "AL",
            "code_full": "ALB"
        ],
        [
            "en": "Algeria",
            "ru": "Algeria",
            "dial_code": "+213",
            "code": "DZ",
            "code_full": "DZA"
        ],
        [
            "en": "American Samoa",
            "ru": "AmericanSamoa",
            "dial_code": "+1 684",
            "code": "AS",
            "code_full": "ASM"
        ],
        [
            "en": "Andorra",
            "ru": "Andorra",
            "dial_code": "+376",
            "code": "AD",
            "code_full": "AND"
        ],
        [
            "en": "Angola",
            "ru": "Angola",
            "dial_code": "+244",
            "code": "AO",
            "code_full": "AGO"
        ],
        [
            "en": "Anguilla",
            "ru": "Anguilla",
            "dial_code": "+1 264",
            "code": "AI",
            "code_full": "AIA"
        ],
        [
            "en": "Antigua and Barbuda",
            "ru": "Antigua and Barbuda",
            "dial_code": "+1268",
            "code": "AG",
            "code_full": "ATG"
        ],
        [
            "en": "Argentina",
            "ru": "Argentina",
            "dial_code": "+54",
            "code": "AR",
            "code_full": "ARG"
        ],
        [
            "en": "Armenia",
            "ru": "Armenia",
            "dial_code": "+374",
            "code": "AM",
            "code_full": "ARM"
        ],
        [
            "en": "Aruba",
            "ru": "Aruba",
            "dial_code": "+297",
            "code": "AW",
            "code_full": "ABW"
        ],
        [
            "en": "Australia",
            "ru": "Australia",
            "dial_code": "+61",
            "code": "AU",
            "code_full": "AUS"
        ],
        [
            "en": "Austria",
            "ru": "Austria",
            "dial_code": "+43",
            "code": "AT",
            "code_full": "AUT"
        ],
        [
            "en": "Azerbaijan",
            "ru": "Azerbaijan",
            "dial_code": "+994",
            "code": "AZ",
            "code_full": "AZE"
        ],
        [
            "en": "Bahamas",
            "ru": "Bahamas",
            "dial_code": "+1 242",
            "code": "BS",
            "code_full": "BHS"
        ],
        [
            "en": "Bahrain",
            "ru": "Bahrain",
            "dial_code": "+973",
            "code": "BH",
            "code_full": "BHR"
        ],
        [
            "en": "Bangladesh",
            "ru": "Bangladesh",
            "dial_code": "+880",
            "code": "BD",
            "code_full": "BGD"
        ],
        [
            "en": "Barbados",
            "ru": "Barbados",
            "dial_code": "+1 246",
            "code": "BB",
            "code_full": "BRB"
        ],
        [
            "en": "Belarus",
            "ru": "Belarus",
            "dial_code": "+375",
            "code": "BY",
            "code_full": "BLR"
        ],
        [
            "en": "Belgium",
            "ru": "Belgium",
            "dial_code": "+32",
            "code": "BE",
            "code_full": "BEL"
        ],
        [
            "en": "Belize",
            "ru": "Belize",
            "dial_code": "+501",
            "code": "BZ",
            "code_full": "BLZ"
        ],
        [
            "en": "Benin",
            "ru": "Benin",
            "dial_code": "+229",
            "code": "BJ",
            "code_full": "BEN"
        ],
        [
            "en": "Bermuda",
            "ru": "Bermuda",
            "dial_code": "+1 441",
            "code": "BM",
            "code_full": "BMU"
        ],
        [
            "en": "Bhutan",
            "ru": "Bhutan",
            "dial_code": "+975",
            "code": "BT",
            "code_full": "BTN"
        ],
        [
            "en": "Plurinational State of Bolivia",
            "ru": "Plurinational State of Bolivia",
            "dial_code": "+591",
            "code": "BO",
            "code_full": "BOL"
        ],
        [
            "en": "Bosnia and Herzegovina",
            "ru": "Bosnia and Herzegovina",
            "dial_code": "+387",
            "code": "BA",
            "code_full": "BIH"
        ],
        [
            "en": "Botswana",
            "ru": "Botswana",
            "dial_code": "+267",
            "code": "BW",
            "code_full": "BWA"
        ],
        [
            "en": "Brazil",
            "ru": "Brazil",
            "dial_code": "+55",
            "code": "BR",
            "code_full": "BRA"
        ],
        [
            "en": "British Indian Ocean Territory",
            "ru": "British Indian Ocean Territory",
            "dial_code": "+246",
            "code": "IO",
            "code_full": "IOT"
        ],
        [
            "en": "Brunei Darussalam",
            "ru": "Brunei Darussalam",
            "dial_code": "+673",
            "code": "BN",
            "code_full": "BRN"
        ],
        [
            "en": "Bulgaria",
            "ru": "Bulgaria",
            "dial_code": "+359",
            "code": "BG",
            "code_full": "BGR"
        ],
        [
            "en": "Burkina Faso",
            "ru": "Burkina Faso",
            "dial_code": "+226",
            "code": "BF",
            "code_full": "BFA"
        ],
        [
            "en": "Burundi",
            "ru": "Burundi",
            "dial_code": "+257",
            "code": "BI",
            "code_full": "BDI"
        ],
        [
            "en": "Cambodia",
            "ru": "Cambodia",
            "dial_code": "+855",
            "code": "KH",
            "code_full": "KHM"
        ],
        [
            "en": "Cameroon",
            "ru": "Cameroon",
            "dial_code": "+237",
            "code": "CM",
            "code_full": "CMR"
        ],
        [
            "en": "Canada",
            "ru": "Canada",
            "dial_code": "+1",
            "code": "CA",
            "code_full": "CAN"
        ],
        [
            "en": "Cape Verde",
            "ru": "Cape Verde",
            "dial_code": "+238",
            "code": "CV",
            "code_full": "CPV"
        ],
        [
            "en": "Cayman Islands",
            "ru": "Cayman Islands",
            "dial_code": "+ 345",
            "code": "KY",
            "code_full": "CYM"
        ],
        [
            "en": "Central African Republic",
            "ru": "Central African Republic",
            "dial_code": "+236",
            "code": "CF",
            "code_full": "CAF"
        ],
        [
            "en": "Chad",
            "ru": "Chad",
            "dial_code": "+235",
            "code": "TD",
            "code_full": "TCD"
        ],
        [
            "en": "Chile",
            "ru": "Chile",
            "dial_code": "+56",
            "code": "CL",
            "code_full": "CHL"
        ],
        [
            "en": "China",
            "ru": "China",
            "dial_code": "+86",
            "code": "CN",
            "code_full": "CHN"
        ],
        [
            "en": "Christmas Island",
            "ru": "Christmas Island",
            "dial_code": "+61",
            "code": "CX",
            "code_full": "CXR"
        ],
        [
            "en": "Cocos (Keeling) Islands",
            "ru": "Cocos (Keeling) Islands",
            "dial_code": "+61",
            "code": "CC",
            "code_full": "CCK"
        ],
        [
            "en": "Colombia",
            "ru": "Colombia",
            "dial_code": "+57",
            "code": "CO",
            "code_full": "COL"
        ],
        [
            "en": "Comoros",
            "ru": "Comoros",
            "dial_code": "+269",
            "code": "KM",
            "code_full": "COM"
        ],
        [
            "en": "Congo",
            "ru": "Congo",
            "dial_code": "+242",
            "code": "CG",
            "code_full": "COG"
        ],
        [
            "en": "Congo, The Democratic Republic of the Congo",
            "ru": "Congo, The Democratic Republic of the Congo",
            "dial_code": "+243",
            "code": "CD",
            "code_full": "COD"
        ],
        [
            "en": "Cook Islands",
            "ru": "Cook Islands",
            "dial_code": "+682",
            "code": "CK",
            "code_full": "COK"
        ],
        [
            "en": "Costa Rica",
            "ru": "Costa Rica",
            "dial_code": "+506",
            "code": "CR",
            "code_full": "CRI"
        ],
        [
            "en": "Cote d'Ivoire",
            "ru": "Cote d'Ivoire",
            "dial_code": "+225",
            "code": "CI",
            "code_full": "CIV"
        ],
        [
            "en": "Croatia",
            "ru": "Croatia",
            "dial_code": "+385",
            "code": "HR",
            "code_full": "HRV"
        ],
        [
            "en": "Cuba",
            "ru": "Cuba",
            "dial_code": "+53",
            "code": "CU",
            "code_full": "CUB"
        ],
        [
            "en": "Cyprus",
            "ru": "Cyprus",
            "dial_code": "+357",
            "code": "CY",
            "code_full": "CYP"
        ],
        [
            "en": "Czech Republic",
            "ru": "Czech Republic",
            "dial_code": "+420",
            "code": "CZ",
            "code_full": "CZE"
        ],
        [
            "en": "Denmark",
            "ru": "Denmark",
            "dial_code": "+45",
            "code": "DK",
            "code_full": "DNK"
        ],
        [
            "en": "Djibouti",
            "ru": "Djibouti",
            "dial_code": "+253",
            "code": "DJ",
            "code_full": "DJI"
        ],
        [
            "en": "Dominica",
            "ru": "Dominica",
            "dial_code": "+1 767",
            "code": "DM",
            "code_full": "DMA"
        ],
        [
            "en": "Dominican Republic",
            "ru": "Dominican Republic",
            "dial_code": "+1 849",
            "code": "DO",
            "code_full": "DOM"
        ],
        [
            "en": "Ecuador",
            "ru": "Ecuador",
            "dial_code": "+593",
            "code": "EC",
            "code_full": "ECU"
        ],
        [
            "en": "Egypt",
            "ru": "Egypt",
            "dial_code": "+20",
            "code": "EG",
            "code_full": "EGY"
        ],
        [
            "en": "El Salvador",
            "ru": "El Salvador",
            "dial_code": "+503",
            "code": "SV",
            "code_full": "SLV"
        ],
        [
            "en": "Equatorial Guinea",
            "ru": "Equatorial Guinea",
            "dial_code": "+240",
            "code": "GQ",
            "code_full": "GNQ"
        ],
        [
            "en": "Eritrea",
            "ru": "Eritrea",
            "dial_code": "+291",
            "code": "ER",
            "code_full": "ERI"
        ],
        [
            "en": "Estonia",
            "ru": "Estonia",
            "dial_code": "+372",
            "code": "EE",
            "code_full": "EST"
        ],
        [
            "en": "Ethiopia",
            "ru": "Ethiopia",
            "dial_code": "+251",
            "code": "ET",
            "code_full": "ETH"
        ],
        [
            "en": "Falkland Islands (Malvinas)",
            "ru": "Falkland Islands (Malvinas)",
            "dial_code": "+500",
            "code": "FK",
            "code_full": "FLK"
        ],
        [
            "en": "Faroe Islands",
            "ru": "Faroe Islands",
            "dial_code": "+298",
            "code": "FO",
            "code_full": "FRO"
        ],
        [
            "en": "Fiji",
            "ru": "Fiji",
            "dial_code": "+679",
            "code": "FJ",
            "code_full": "FJI"
        ],
        [
            "en": "Finland",
            "ru": "Finland",
            "dial_code": "+358",
            "code": "FI",
            "code_full": "FIN"
        ],
        [
            "en": "France",
            "ru": "France",
            "dial_code": "+33",
            "code": "FR",
            "code_full": "FRA"
        ],
        [
            "en": "French Guiana",
            "ru": "French Guiana",
            "dial_code": "+594",
            "code": "GF",
            "code_full": "GUF"
        ],
        [
            "en": "French Polynesia",
            "ru": "French Polynesia",
            "dial_code": "+689",
            "code": "PF",
            "code_full": "PYF"
        ],
        [
            "en": "Gabon",
            "ru": "Gabon",
            "dial_code": "+241",
            "code": "GA",
            "code_full": "GAB"
        ],
        [
            "en": "Gambia",
            "ru": "Gambia",
            "dial_code": "+220",
            "code": "GM",
            "code_full": "GMB"
        ],
        [
            "en": "Georgia",
            "ru": "Georgia",
            "dial_code": "+995",
            "code": "GE",
            "code_full": "GEO"
        ],
        [
            "en": "Germany",
            "ru": "Germany",
            "dial_code": "+49",
            "code": "DE",
            "code_full": "DEU"
        ],
        [
            "en": "Ghana",
            "ru": "Ghana",
            "dial_code": "+233",
            "code": "GH",
            "code_full": "GHA"
        ],
        [
            "en": "Gibraltar",
            "ru": "Gibraltar",
            "dial_code": "+350",
            "code": "GI",
            "code_full": "GIB"
        ],
        [
            "en": "Greece",
            "ru": "Greece",
            "dial_code": "+30",
            "code": "GR",
            "code_full": "GRC"
        ],
        [
            "en": "Greenland",
            "ru": "Greenland",
            "dial_code": "+299",
            "code": "GL",
            "code_full": "GRL"
        ],
        [
            "en": "Grenada",
            "ru": "Grenada",
            "dial_code": "+1 473",
            "code": "GD",
            "code_full": "GRD"
        ],
        [
            "en": "Guadeloupe",
            "ru": "Guadeloupe",
            "dial_code": "+590",
            "code": "GP",
            "code_full": "GLP"
        ],
        [
            "en": "Guam",
            "ru": "Guam",
            "dial_code": "+1 671",
            "code": "GU",
            "code_full": "GUM"
        ],
        [
            "en": "Guatemala",
            "ru": "Guatemala",
            "dial_code": "+502",
            "code": "GT",
            "code_full": "GTM"
        ],
        [
            "en": "Guernsey",
            "ru": "Guernsey",
            "dial_code": "+44",
            "code": "GG",
            "code_full": "GGY"
        ],
        [
            "en": "Guinea",
            "ru": "Guinea",
            "dial_code": "+224",
            "code": "GN",
            "code_full": "GIN"
        ],
        [
            "en": "Guinea-Bissau",
            "ru": "Guinea-Bissau",
            "dial_code": "+245",
            "code": "GW",
            "code_full": "GNB"
        ],
        [
            "en": "Guyana",
            "ru": "Guyana",
            "dial_code": "+595",
            "code": "GY",
            "code_full": "GUY"
        ],
        [
            "en": "Haiti",
            "ru": "Haiti",
            "dial_code": "+509",
            "code": "HT",
            "code_full": "HTI"
        ],
        [
            "en": "Holy See (Vatican City State)",
            "ru": "Holy See (Vatican City State)",
            "dial_code": "+379",
            "code": "VA",
            "code_full": "VAT"
        ],
        [
            "en": "Honduras",
            "ru": "Honduras",
            "dial_code": "+504",
            "code": "HN",
            "code_full": "HND"
        ],
        [
            "en": "Hong Kong",
            "ru": "Hong Kong",
            "dial_code": "+852",
            "code": "HK",
            "code_full": "HKG"
        ],
        [
            "en": "Hungary",
            "ru": "Hungary",
            "dial_code": "+36",
            "code": "HU",
            "code_full": "HUN"
        ],
        [
            "en": "Iceland",
            "ru": "Iceland",
            "dial_code": "+354",
            "code": "IS",
            "code_full": "ISL"
        ],
        [
            "en": "India",
            "ru": "India",
            "dial_code": "+91",
            "code": "IN",
            "code_full": "IND"
        ],
        [
            "en": "Indonesia",
            "ru": "Indonesia",
            "dial_code": "+62",
            "code": "ID",
            "code_full": "IDN"
        ],
        [
            "en": "Iran, Islamic Republic of Persian Gulf",
            "ru": "Iran, Islamic Republic of Persian Gulf",
            "dial_code": "+98",
            "code": "IR",
            "code_full": "IRN"
        ],
        [
            "en": "Iraq",
            "ru": "Iraq",
            "dial_code": "+964",
            "code": "IQ",
            "code_full": "IRQ"
        ],
        [
            "en": "Ireland",
            "ru": "Ireland",
            "dial_code": "+353",
            "code": "IE",
            "code_full": "IRL"
        ],
        [
            "en": "Isle of Man",
            "ru": "Isle of Man",
            "dial_code": "+44",
            "code": "IM",
            "code_full": "IMN"
        ],
        [
            "en": "Israel",
            "ru": "Israel",
            "dial_code": "+972",
            "code": "IL",
            "code_full": "ISR"
        ],
        [
            "en": "Italy",
            "ru": "Italy",
            "dial_code": "+39",
            "code": "IT",
            "code_full": "ITA"
        ],
        [
            "en": "Jamaica",
            "ru": "Jamaica",
            "dial_code": "+1 876",
            "code": "JM",
            "code_full": "JAM"
        ],
        [
            "en": "Japan",
            "ru": "Japan",
            "dial_code": "+81",
            "code": "JP",
            "code_full": "JPN"
        ],
        [
            "en": "Jersey",
            "ru": "Jersey",
            "dial_code": "+44",
            "code": "JE",
            "code_full": "JEY"
        ],
        [
            "en": "Jordan",
            "ru": "Jordan",
            "dial_code": "+962",
            "code": "JO",
            "code_full": "JOR"
        ],
        [
            "en": "Kazakhstan",
            "ru": "Kazakhstan",
            "dial_code": "+7 7",
            "code": "KZ",
            "code_full": "KAZ"
        ],
        [
            "en": "Kenya",
            "ru": "Kenya",
            "dial_code": "+254",
            "code": "KE",
            "code_full": "KEN"
        ],
        [
            "en": "Kiribati",
            "ru": "Kiribati",
            "dial_code": "+686",
            "code": "KI",
            "code_full": "KIR"
        ],
        [
            "en": "Korea, Democratic People's Republic of Korea",
            "ru": "Korea, Democratic People's Republic of Korea",
            "dial_code": "+850",
            "code": "KP",
            "code_full": "PRK"
        ],
        [
            "en": "Korea, Republic of South Korea",
            "ru": "Korea, Republic of South Korea",
            "dial_code": "+82",
            "code": "KR",
            "code_full": "KOR"
        ],
        [
            "en": "Kuwait",
            "ru": "Kuwait",
            "dial_code": "+965",
            "code": "KW",
            "code_full": "KWT"
        ],
        [
            "en": "Kyrgyzstan",
            "ru": "Kyrgyzstan",
            "dial_code": "+996",
            "code": "KG",
            "code_full": "KGZ"
        ],
        [
            "en": "Laos",
            "ru": "Laos",
            "dial_code": "+856",
            "code": "LA",
            "code_full": "LAO"
        ],
        [
            "en": "Latvia",
            "ru": "Latvia",
            "dial_code": "+371",
            "code": "LV",
            "code_full": "LVA"
        ],
        [
            "en": "Lebanon",
            "ru": "Lebanon",
            "dial_code": "+961",
            "code": "LB",
            "code_full": "LBN"
        ],
        [
            "en": "Lesotho",
            "ru": "Lesotho",
            "dial_code": "+266",
            "code": "LS",
            "code_full": "LSO"
        ],
        [
            "en": "Liberia",
            "ru": "Liberia",
            "dial_code": "+231",
            "code": "LR",
            "code_full": "LBR"
        ],
        [
            "en": "Libyan Arab Jamahiriya",
            "ru": "Libyan Arab Jamahiriya",
            "dial_code": "+218",
            "code": "LY",
            "code_full": "LBY"
        ],
        [
            "en": "Liechtenstein",
            "ru": "Liechtenstein",
            "dial_code": "+423",
            "code": "LI",
            "code_full": "LIE"
        ],
        [
            "en": "Lithuania",
            "ru": "Lithuania",
            "dial_code": "+370",
            "code": "LT",
            "code_full": "LTU"
        ],
        [
            "en": "Luxembourg",
            "ru": "Luxembourg",
            "dial_code": "+352",
            "code": "LU",
            "code_full": "LUX"
        ],
        [
            "en": "Macao",
            "ru": "Macao",
            "dial_code": "+853",
            "code": "MO",
            "code_full": "MAC"
        ],
        [
            "en": "Macedonia",
            "ru": "Macedonia",
            "dial_code": "+389",
            "code": "MK",
            "code_full": "MKD"
        ],
        [
            "en": "Madagascar",
            "ru": "Madagascar",
            "dial_code": "+261",
            "code": "MG",
            "code_full": "MDG"
        ],
        [
            "en": "Malawi",
            "ru": "Malawi",
            "dial_code": "+265",
            "code": "MW",
            "code_full": "MWI"
        ],
        [
            "en": "Malaysia",
            "ru": "Malaysia",
            "dial_code": "+60",
            "code": "MY",
            "code_full": "MYS"
        ],
        [
            "en": "Maldives",
            "ru": "Maldives",
            "dial_code": "+960",
            "code": "MV",
            "code_full": "MDV"
        ],
        [
            "en": "Mali",
            "ru": "Mali",
            "dial_code": "+223",
            "code": "ML",
            "code_full": "MLI"
        ],
        [
            "en": "Malta",
            "ru": "Malta",
            "dial_code": "+356",
            "code": "MT",
            "code_full": "MLT"
        ],
        [
            "en": "Marshall Islands",
            "ru": "Marshall Islands",
            "dial_code": "+692",
            "code": "MH",
            "code_full": "MHL"
        ],
        [
            "en": "Martinique",
            "ru": "Martinique",
            "dial_code": "+596",
            "code": "MQ",
            "code_full": "MTQ"
        ],
        [
            "en": "Mauritania",
            "ru": "Mauritania",
            "dial_code": "+222",
            "code": "MR",
            "code_full": "MRT"
        ],
        [
            "en": "Mauritius",
            "ru": "Mauritius",
            "dial_code": "+230",
            "code": "MU",
            "code_full": "MUS"
        ],
        [
            "en": "Mayotte",
            "ru": "Mayotte",
            "dial_code": "+262",
            "code": "YT",
            "code_full": "MYT"
        ],
        [
            "en": "Mexico",
            "ru": "Mexico",
            "dial_code": "+52",
            "code": "MX",
            "code_full": "MEX"
        ],
        [
            "en": "Micronesia, Federated States of Micronesia",
            "ru": "Micronesia, Federated States of Micronesia",
            "dial_code": "+691",
            "code": "FM",
            "code_full": "FSM"
        ],
        [
            "en": "Moldova",
            "ru": "Moldova",
            "dial_code": "+373",
            "code": "MD",
            "code_full": "MDA"
        ],
        [
            "en": "Monaco",
            "ru": "Monaco",
            "dial_code": "+377",
            "code": "MC",
            "code_full": "MCO"
        ],
        [
            "en": "Mongolia",
            "ru": "Mongolia",
            "dial_code": "+976",
            "code": "MN",
            "code_full": "MNG"
        ],
        [
            "en": "Montenegro",
            "ru": "Montenegro",
            "dial_code": "+382",
            "code": "ME",
            "code_full": "MNE"
        ],
        [
            "en": "Montserrat",
            "ru": "Montserrat",
            "dial_code": "+1664",
            "code": "MS",
            "code_full": "MSR"
        ],
        [
            "en": "Morocco",
            "ru": "Morocco",
            "dial_code": "+212",
            "code": "MA",
            "code_full": "MAR"
        ],
        [
            "en": "Mozambique",
            "ru": "Mozambique",
            "dial_code": "+258",
            "code": "MZ",
            "code_full": "MOZ"
        ],
        [
            "en": "Myanmar",
            "ru": "Myanmar",
            "dial_code": "+95",
            "code": "MM",
            "code_full": "MMR"
        ],
        [
            "en": "Namibia",
            "ru": "Namibia",
            "dial_code": "+264",
            "code": "NA",
            "code_full": "NAM"
        ],
        [
            "en": "Nauru",
            "ru": "Nauru",
            "dial_code": "+674",
            "code": "NR",
            "code_full": "NRU"
        ],
        [
            "en": "Nepal",
            "ru": "Nepal",
            "dial_code": "+977",
            "code": "NP",
            "code_full": "NPL"
        ],
        [
            "en": "Netherlands",
            "ru": "Netherlands",
            "dial_code": "+31",
            "code": "NL",
            "code_full": "NLD"
        ],
        [
            "en": "Netherlands Antilles",
            "ru": "Netherlands Antilles",
            "dial_code": "+599",
            "code": "AN",
            "code_full": "ANT"
        ],
        [
            "en": "New Caledonia",
            "ru": "New Caledonia",
            "dial_code": "+687",
            "code": "NC",
            "code_full": "NCL"
        ],
        [
            "en": "New Zealand",
            "ru": "New Zealand",
            "dial_code": "+64",
            "code": "NZ",
            "code_full": "NZL"
        ],
        [
            "en": "Nicaragua",
            "ru": "Nicaragua",
            "dial_code": "+505",
            "code": "NI",
            "code_full": "NIC"
        ],
        [
            "en": "Niger",
            "ru": "Niger",
            "dial_code": "+227",
            "code": "NE",
            "code_full": "NER"
        ],
        [
            "en": "Nigeria",
            "ru": "Nigeria",
            "dial_code": "+234",
            "code": "NG",
            "code_full": "NGA"
        ],
        [
            "en": "Niue",
            "ru": "Niue",
            "dial_code": "+683",
            "code": "NU",
            "code_full": "NIU"
        ],
        [
            "en": "Norfolk Island",
            "ru": "Norfolk Island",
            "dial_code": "+672",
            "code": "NF",
            "code_full": "NFK"
        ],
        [
            "en": "Northern Mariana Islands",
            "ru": "Northern Mariana Islands",
            "dial_code": "+1 670",
            "code": "MP",
            "code_full": "MNP"
        ],
        [
            "en": "Norway",
            "ru": "Norway",
            "dial_code": "+47",
            "code": "NO",
            "code_full": "NOR"
        ],
        [
            "en": "Oman",
            "ru": "Oman",
            "dial_code": "+968",
            "code": "OM",
            "code_full": "OMN"
        ],
        [
            "en": "Pakistan",
            "ru": "Pakistan",
            "dial_code": "+92",
            "code": "PK",
            "code_full": "PAK"
        ],
        [
            "en": "Palau",
            "ru": "Palau",
            "dial_code": "+680",
            "code": "PW",
            "code_full": "PLW"
        ],
        [
            "en": "Palestinian Territory, Occupied",
            "ru": "Palestinian Territory, Occupied",
            "dial_code": "+970",
            "code": "PS",
            "code_full": "PSE"
        ],
        [
            "en": "Panama",
            "ru": "Panama",
            "dial_code": "+507",
            "code": "PA",
            "code_full": "PAN"
        ],
        [
            "en": "Papua New Guinea",
            "ru": "Papua New Guinea",
            "dial_code": "+675",
            "code": "PG",
            "code_full": "PNG"
        ],
        [
            "en": "Paraguay",
            "ru": "Paraguay",
            "dial_code": "+595",
            "code": "PY",
            "code_full": "PRY"
        ],
        [
            "en": "Peru",
            "ru": "Peru",
            "dial_code": "+51",
            "code": "PE",
            "code_full": "PER"
        ],
        [
            "en": "Philippines",
            "ru": "Philippines",
            "dial_code": "+63",
            "code": "PH",
            "code_full": "PHL"
        ],
        [
            "en": "Pitcairn",
            "ru": "Pitcairn",
            "dial_code": "+872",
            "code": "PN",
            "code_full": "PCN"
        ],
        [
            "en": "Poland",
            "ru": "Poland",
            "dial_code": "+48",
            "code": "PL",
            "code_full": "POL"
        ],
        [
            "en": "Portugal",
            "ru": "Portugal",
            "dial_code": "+351",
            "code": "PT",
            "code_full": "PRT"
        ],
        [
            "en": "Puerto Rico",
            "ru": "Puerto Rico",
            "dial_code": "+1 939",
            "code": "PR",
            "code_full": "PRI"
        ],
        [
            "en": "Qatar",
            "ru": "Qatar",
            "dial_code": "+974",
            "code": "QA",
            "code_full": "QAT"
        ],
        [
            "en": "Romania",
            "ru": "Romania",
            "dial_code": "+40",
            "code": "RO",
            "code_full": "ROU"
        ],
        [
            "en": "Russia",
            "ru": "Russia",
            "dial_code": "+7",
            "code": "RU",
            "code_full": "RUS"
        ],
        [
            "en": "Rwanda",
            "ru": "Rwanda",
            "dial_code": "+250",
            "code": "RW",
            "code_full": "RWA"
        ],
        [
            "en": "Reunion",
            "ru": "Reunion",
            "dial_code": "+262",
            "code": "RE",
            "code_full": "REU"
        ],
        [
            "en": "Saint Barthelemy",
            "ru": "Saint Barthelemy",
            "dial_code": "+590",
            "code": "BL",
            "code_full": "BLM"
        ],
        [
            "en": "Saint Helena, Ascension and Tristan Da Cunha",
            "ru": "Saint Helena, Ascension and Tristan Da Cunha",
            "dial_code": "+290",
            "code": "SH",
            "code_full": "SHN"
        ],
        [
            "en": "Saint Kitts and Nevis",
            "ru": "Saint Kitts and Nevis",
            "dial_code": "+1 869",
            "code": "KN",
            "code_full": "KNA"
        ],
        [
            "en": "Saint Lucia",
            "ru": "Saint Lucia",
            "dial_code": "+1 758",
            "code": "LC",
            "code_full": "LCA"
        ],
        [
            "en": "Saint Martin",
            "ru": "Saint Martin",
            "dial_code": "+590",
            "code": "MF",
            "code_full": "MAF"
        ],
        [
            "en": "Saint Pierre and Miquelon",
            "ru": "Saint Pierre and Miquelon",
            "dial_code": "+508",
            "code": "PM",
            "code_full": "SPM"
        ],
        [
            "en": "Saint Vincent and the Grenadines",
            "ru": "Saint Vincent and the Grenadines",
            "dial_code": "+1 784",
            "code": "VC",
            "code_full": "VCT"
        ],
        [
            "en": "Samoa",
            "ru": "Samoa",
            "dial_code": "+685",
            "code": "WS",
            "code_full": "WSM"
        ],
        [
            "en": "San Marino",
            "ru": "San Marino",
            "dial_code": "+378",
            "code": "SM",
            "code_full": "SMR"
        ],
        [
            "en": "Sao Tome and Principe",
            "ru": "Sao Tome and Principe",
            "dial_code": "+239",
            "code": "ST",
            "code_full": "STP"
        ],
        [
            "en": "Saudi Arabia",
            "ru": "Saudi Arabia",
            "dial_code": "+966",
            "code": "SA",
            "code_full": "SAU"
        ],
        [
            "en": "Senegal",
            "ru": "Senegal",
            "dial_code": "+221",
            "code": "SN",
            "code_full": "SEN"
        ],
        [
            "en": "Serbia",
            "ru": "Serbia",
            "dial_code": "+381",
            "code": "RS",
            "code_full": "SRB"
        ],
        [
            "en": "Seychelles",
            "ru": "Seychelles",
            "dial_code": "+248",
            "code": "SC",
            "code_full": "SYC"
        ],
        [
            "en": "Sierra Leone",
            "ru": "Sierra Leone",
            "dial_code": "+232",
            "code": "SL",
            "code_full": "SLE"
        ],
        [
            "en": "Singapore",
            "ru": "Singapore",
            "dial_code": "+65",
            "code": "SG",
            "code_full": "SGP"
        ],
        [
            "en": "Slovakia",
            "ru": "Slovakia",
            "dial_code": "+421",
            "code": "SK",
            "code_full": "SVK"
        ],
        [
            "en": "Slovenia",
            "ru": "Slovenia",
            "dial_code": "+386",
            "code": "SI",
            "code_full": "SVN"
        ],
        [
            "en": "Solomon Islands",
            "ru": "Solomon Islands",
            "dial_code": "+677",
            "code": "SB",
            "code_full": "SLB"
        ],
        [
            "en": "Somalia",
            "ru": "Somalia",
            "dial_code": "+252",
            "code": "SO",
            "code_full": "SOM"
        ],
        [
            "en": "South Africa",
            "ru": "South Africa",
            "dial_code": "+27",
            "code": "ZA",
            "code_full": "ZAF"
        ],
        [
            "en": "South Georgia and the South Sandwich Islands",
            "ru": "South Georgia and the South Sandwich Islands",
            "dial_code": "+500",
            "code": "GS",
            "code_full": "SGS"
        ],
        [
            "en": "Spain",
            "ru": "Spain",
            "dial_code": "+34",
            "code": "ES",
            "code_full": "ESP"
        ],
        [
            "en": "Sri Lanka",
            "ru": "Sri Lanka",
            "dial_code": "+94",
            "code": "LK",
            "code_full": "LKA"
        ],
        [
            "en": "Sudan",
            "ru": "Sudan",
            "dial_code": "+249",
            "code": "SD",
            "code_full": "SDN"
        ],
        [
            "en": "Surien",
            "ru": "Surien",
            "dial_code": "+597",
            "code": "SR",
            "code_full": "SUR"
        ],
        [
            "en": "Svalbard and Jan Mayen",
            "ru": "Svalbard and Jan Mayen",
            "dial_code": "+47",
            "code": "SJ",
            "code_full": "SJM"
        ],
        [
            "en": "Swaziland",
            "ru": "Swaziland",
            "dial_code": "+268",
            "code": "SZ",
            "code_full": "SWZ"
        ],
        [
            "en": "Sweden",
            "ru": "Sweden",
            "dial_code": "+46",
            "code": "SE",
            "code_full": "SWE"
        ],
        [
            "en": "Switzerland",
            "ru": "Switzerland",
            "dial_code": "+41",
            "code": "CH",
            "code_full": "CHE"
        ],
        [
            "en": "Syrian Arab Republic",
            "ru": "Syrian Arab Republic",
            "dial_code": "+963",
            "code": "SY",
            "code_full": "SYR"
        ],
        [
            "en": "Taiwan",
            "ru": "Taiwan",
            "dial_code": "+886",
            "code": "TW",
            "code_full": "TWN"
        ],
        [
            "en": "Tajikistan",
            "ru": "Tajikistan",
            "dial_code": "+992",
            "code": "TJ",
            "code_full": "TJK"
        ],
        [
            "en": "Tanzania, United Republic of Tanzania",
            "ru": "Tanzania, United Republic of Tanzania",
            "dial_code": "+255",
            "code": "TZ",
            "code_full": "TZA"
        ],
        [
            "en": "Thailand",
            "ru": "Thailand",
            "dial_code": "+66",
            "code": "TH",
            "code_full": "THA"
        ],
        [
            "en": "Timor-Leste",
            "ru": "Timor-Leste",
            "dial_code": "+670",
            "code": "TL",
            "code_full": "TLS"
        ],
        [
            "en": "Togo",
            "ru": "Togo",
            "dial_code": "+228",
            "code": "TG",
            "code_full": "TGO"
        ],
        [
            "en": "Tokelau",
            "ru": "Tokelau",
            "dial_code": "+690",
            "code": "TK",
            "code_full": "TKL"
        ],
        [
            "en": "Tonga",
            "ru": "Tonga",
            "dial_code": "+676",
            "code": "TO",
            "code_full": "TON"
        ],
        [
            "en": "Trinidad and Tobago",
            "ru": "Trinidad and Tobago",
            "dial_code": "+1 868",
            "code": "TT",
            "code_full": "TTO"
        ],
        [
            "en": "Tunisia",
            "ru": "Tunisia",
            "dial_code": "+216",
            "code": "TN",
            "code_full": "TUN"
        ],
        [
            "en": "Turkey",
            "ru": "Turkey",
            "dial_code": "+90",
            "code": "TR",
            "code_full": "TUR"
        ],
        [
            "en": "Turkmenistan",
            "ru": "Turkmenistan",
            "dial_code": "+993",
            "code": "TM",
            "code_full": "TKM"
        ],
        [
            "en": "Turks and Caicos Islands",
            "ru": "Turks and Caicos Islands",
            "dial_code": "+1 649",
            "code": "TC",
            "code_full": "TCA"
        ],
        [
            "en": "Tuvalu",
            "ru": "Tuvalu",
            "dial_code": "+688",
            "code": "TV",
            "code_full": "TUV"
        ],
        [
            "en": "Uganda",
            "ru": "Uganda",
            "dial_code": "+256",
            "code": "UG",
            "code_full": "UGA"
        ],
        [
            "en": "Ukraine",
            "ru": "Ukraine",
            "dial_code": "+380",
            "code": "UA",
            "code_full": "UKR"
        ],
        [
            "en": "United Arab Emirates",
            "ru": "United Arab Emirates",
            "dial_code": "+971",
            "code": "AE",
            "code_full": "ARE"
        ],
        [
            "en": "United Kingdom",
            "ru": "United Kingdom",
            "dial_code": "+44",
            "code": "GB",
            "code_full": "GBR"
        ],
        [
            "en": "United States of America",
            "ru": "United States of America",
            "dial_code": "+1",
            "code": "US",
            "code_full": "USA"
        ],
        [
            "en": "Uruguay",
            "ru": "Uruguay",
            "dial_code": "+598",
            "code": "UY",
            "code_full": "URY"
        ],
        [
            "en": "Uzbekistan",
            "ru": "Uzbekistan",
            "dial_code": "+998",
            "code": "UZ",
            "code_full": "UZB"
        ],
        [
            "en": "Vanuatu",
            "ru": "Vanuatu",
            "dial_code": "+678",
            "code": "VU",
            "code_full": "VUT"
        ],
        [
            "en": "Venezuela, Bolivarian Republic of Venezuela",
            "ru": "Venezuela, Bolivarian Republic of Venezuela",
            "dial_code": "+58",
            "code": "VE",
            "code_full": "VEN"
        ],
        [
            "en": "Vietnam",
            "ru": "Vietnam",
            "dial_code": "+84",
            "code": "VN",
            "code_full": "VNM"
        ],
        [
            "en": "Virgin Islands, British",
            "ru": "Virgin Islands, British",
            "dial_code": "+1 284",
            "code": "VG",
            "code_full": "VGB"
        ],
        [
            "en": "Virgin Islands, U.S.",
            "ru": "Virgin Islands, U.S.",
            "dial_code": "+1 340",
            "code": "VI",
            "code_full": "VIR"
        ],
        [
            "en": "Wallis and Futuna",
            "ru": "Wallis and Futuna",
            "dial_code": "+681",
            "code": "WF",
            "code_full": "WLF"
        ],
        [
            "en": "Yemen",
            "ru": "Yemen",
            "dial_code": "+967",
            "code": "YE",
            "code_full": "YEM"
        ],
        [
            "en": "Zambia",
            "ru": "Zambia",
            "dial_code": "+260",
            "code": "ZM",
            "code_full": "ZMB"
        ],
        [
            "en": "Zimbabwe",
            "ru": "Zimbabwe",
            "dial_code": "+263",
            "code": "ZW",
            "code_full": "ZWE"
        ]
    ]
}
