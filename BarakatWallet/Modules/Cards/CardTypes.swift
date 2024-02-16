//
//  CardTypes.swift
//  BarakatWallet
//
//  Created by km1tj on 01/02/24.
//

import Foundation
import UIKit

enum CardTypes: String {
    
    case kortimilli = "korimilli"
    case Viza = "viza"
    case MasterCard = "mastercard"
    case AmericanExpress = "amex"
    case UnionPay = "unionpay"
    case DinersClub = "dinersclub"
    
    var pattern: String {
        switch self {
        case .Viza: return "^4[0-9]{1,15}$"
        case .MasterCard: return "^5[1-5][0-9]{0,14}$"
        case .AmericanExpress: return "^3[47][0-9]{0,13}$"
        case .UnionPay: return "^62[0-9]{0,14}$"
        case .DinersClub: return "^3(?:0[0-5,9]|[689][0-9])[0-9]{0,11}$"
        case .kortimilli: return "^(5058|6262|9762|6233)[0-9]{0,12}$"
        }
    }
    var tag: Int {
        switch self {
        case .Viza: return 1
        case .MasterCard: return 2
        case .AmericanExpress: return 3
        case .UnionPay: return 4
        case .DinersClub: return 5
        case .kortimilli: return 6
        }
    }
    var image: UIImage? {
        switch self {
        case .Viza:
            return UIImage(name: .card_visa)
        case .MasterCard:
            return UIImage(name: .card_master)
        case .AmericanExpress:
            return UIImage(name: .card_american)
        case .UnionPay:
            return UIImage(name: .card_union)
        case .DinersClub:
            return UIImage(name: .card_diners)
        case .kortimilli:
            return UIImage(name: .card_milli)
        }
    }
    //visa = ["4"] // length = 16 format = 4-4-4-4
    //masterCard =  ["51", "52", "53", "54", "55"] // length = 16 format = 4-4-4-4
    //amex = ["34", "37"] // length = 15 format = 4-5-6
    //union = ["62"] // length = 16 format = 4-4-4-4
    //dinersClub = ["300", "301", "302", "303", "304", "305", "309", "36", "38", "39"] // length = 14 format = 4-6-4
    //kortimilli = ["5058", "6262", "9762", "6233"] // length = 16 format = 4-4-4-4
    
    static func getBankName(number: String) -> String? {
        if number.starts(with: "505827001") {
            return "ЗАО «ПЕРВЫЙ МИКРОФИНАНСОВЫЙ БАНК»"
        } else if number.starts(with: "505827002") {
            return "ОАО «АГРОИНВЕСТБАНК»"
        } else if number.starts(with: "505827003") || number.starts(with: "505827008") || number.starts(with: "505827011") || number.starts(with: "626238000") || number.starts(with: "626238001") || number.starts(with: "505827041") || number.starts(with: "505827044") || number.starts(with: "505827045") || number.starts(with: "505827052") || number.starts(with: "505827055") || number.starts(with: "505827056") || number.starts(with: "505827057") || number.starts(with: "505827058") || number.starts(with: "505827059") || number.starts(with: "505827060") || number.starts(with: "505827067") || number.starts(with: "976251") || number.starts(with: "976252") || number.starts(with: "97625300") || number.starts(with: "97625301") || number.starts(with: "97625302") || number.starts(with: "97625303") || number.starts(with: "976254") {
            return "ОАО ГСБ «АМОНАТБАНК»"
        } else if number.starts(with: "505827004") || number.starts(with: "505827005") {
            return "ОАО «ТАДЖИКСОДИРОТБАНК»"
        } else if number.starts(with: "505827006") || number.starts(with: "505827007") {
            return "ЗАО «КАФОЛАТБАНК»"
        } else if number.starts(with: "505827009") || number.starts(with: "505827010") || number.starts(with: "62335101") || number.starts(with: "62335102") || number.starts(with: "62335103") {
            return "ЗАО «СПИТАМЕН БОНК»"
        } else if number.starts(with: "505827012") || number.starts(with: "505827013") {
            return "ООО «МАТИН»"
        } else if number.starts(with: "505827014") || number.starts(with: "505827015") {
            return "ЗАО МДО «ИМОН Интернешнл»"
        } else if number.starts(with: "505827016") || number.starts(with: "505827017") {
            return "ЗАО «ПАК НАЦ БАНК»"
        } else if number.starts(with: "505827018") || number.starts(with: "505827019") {
            return "ЗАО «Банк Азия»"
        } else if number.starts(with: "505827020") || number.starts(with: "505827021") {
            return "ЗАО «КАЗКОММЕРТСБОНК»"
        } else if number.starts(with: "505827042") || number.starts(with: "505827043") || number.starts(with: "505827068") {
            return "ОАО «БАНК ЭСХАТА»"
        } else if number.starts(with: "505827022") || number.starts(with: "505827023") {
            return "ЗАО «МЕЖД БАНК ТАДЖИКИСТАНА»"
        } else if number.starts(with: "505827024") || number.starts(with: "505827025") {
            return "ОАО «Коммерцбанк Таджикистан»"
        } else if number.starts(with: "505827026") || number.starts(with: "505827027") || number.starts(with: "505827070") || number.starts(with: "505827084") {
            return "ОАО «ОРИЁНБАНК»"
        } else if number.starts(with: "505827028") || number.starts(with: "505827029") {
            return "ООО МДО «АЛИФ-САРМОЯ»"
        } else if number.starts(with: "505827030") || number.starts(with: "505827031") {
            return "ЗАО МДО “ХУМО”"
        } else if number.starts(with: "505827032") || number.starts(with: "505827033") {
            return "ОАО “Тавхидбанк”"
        } else if number.starts(with: "505827034") || number.starts(with: "505827035") || number.starts(with: "505827036") || number.starts(with: "505827037") || number.starts(with: "505827038") || isDc(number: number) {
            return "ООО МДО «Душанбе Сити»"
        } else if number.starts(with: "505827039") || number.starts(with: "505827040") {
            return "ООО МДО «Тамвил»"
        } else if number.starts(with: "505827046") || number.starts(with: "505827047") {
            return "ООО МДО «Аргун»"
        } else if number.starts(with: "505827048") || number.starts(with: "505827049") {
            return "ЗАО МДО «ЗУДАМАЛ»"
        } else if number.starts(with: "505827050") || number.starts(with: "505827051") || number.starts(with: "505827085") {
            return "ЗАО МДО «ВАСЛ»"
        } else if number.starts(with: "505827053") || number.starts(with: "505827054") {
            return "ЗАО Банк «Арванд»"
        } else if number.starts(with: "505827061") || number.starts(with: "505827062") {
            return "ЗАО FINCA"
        } else if number.starts(with: "505827063") || number.starts(with: "505827064") {
            return "ЗАО МДО «Ардо-капитал»"
        } else if number.starts(with: "505827065") || number.starts(with: "505827066") {
            return "КВД БССТ «Саноатсодиротбонк»"
        } else if number.starts(with: "505827069") || number.starts(with: "505827071") {
            return "ООО МДО «Пайванд Групп»"
        } else if number.starts(with: "505827072") || number.starts(with: "505827073") {
            return "ЗАО МДО «Сандук»"
        } else if number.starts(with: "505827074") || number.starts(with: "505827075") {
            return "ООО МДО «Сарват-М»"
        } else if number.starts(with: "505827076") || number.starts(with: "505827077") {
            return "ООО МДО «ФАЗО С»"
        } else if number.starts(with: "505827078") || number.starts(with: "505827079") {
            return "ЗАО МДО «ШУКР МОЛИЯ»"
        } else if number.starts(with: "505827080") || number.starts(with: "505827081") {
            return "ООО МДО «Эмин Сармоя»"
        } else if number.starts(with: "505827082") || number.starts(with: "505827083") {
            return "ЗАО «Бонки Рушди Точикистон»"
        }
        return nil
    }
    
    static func isDc(number: String) -> Bool {
        let pan = UInt64(number) ?? 0
        if pan >= 9762000000000000 && pan <= 9762499999999999 {
            return true
        }
        return false
    }
    
    static func getCardType(creditCard: String) -> CardTypes? {
        let cards: [CardTypes] = [.AmericanExpress, .DinersClub, .MasterCard, .Viza, .UnionPay, .kortimilli]
        for cardItem in cards {
            if self.regexCheck(pattern: cardItem.pattern, text: creditCard) {
                return cardItem
            }
        }
        return nil
    }
    
    static func formatNumber(creditCard: String) -> String {
        let cards: [CardTypes] = [.AmericanExpress, .DinersClub, .MasterCard, .Viza, .UnionPay, .kortimilli]
        var card: CardTypes? = nil
        for cardItem in cards {
            if self.regexCheck(pattern: cardItem.pattern, text: creditCard) {
                card = cardItem
            }
        }
        let is464 = card == .DinersClub
        let is456 = card == .AmericanExpress
        let is4444 = !(is464 || is456)
        var stringWithAddedSpaces = ""
        for i in 0..<creditCard.count {
            let needs464Spacing = (is464 && (i == 4 || i == 10 || i == 14))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            if needs464Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
            }
            let characterToAdd = creditCard[creditCard.index(creditCard.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        return stringWithAddedSpaces
    }
    
    private static func regexCheck(pattern: String, text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
            return match != nil
        } catch {
            debugPrint(error)
            return false
        }
    }
}
