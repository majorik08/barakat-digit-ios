//
//  HistoryViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift

enum HistoryFilter: Hashable {
    
    case income(set: Bool)
    case expenses(set: Bool)
    case sum(from: Double?, to: Double?)
    case period(from: Date?, to: Date?)
    case operation(type: AppStructs.EntryItem?)
    case payedBy(account: AppStructs.Account?, card: AppStructs.CreditDebitCard?)
    var text: String {
        switch self {
        case .income: return "INCOME".localized
        case .expenses: return "EXPENSES".localized
        case .sum(from: let from, to: let to):
            guard let from, let to else { return "SUM".localized }
            return "\(from)-\(to)"
        case .period(from: let from, to: let to):
            guard let from, let to else { return "PERIOD".localized }
            if from.isInSameDay(as: to) {
                return DateUtils.stringFullDate(date: from)
            } else {
                return "\(DateUtils.stringFullDate(date: from)) - \(DateUtils.stringFullDate(date: to))"
            }
        case .operation(type: let type):
            guard let type else { return "OP_TYPE".localized }
            return type.name
        case .payedBy(account: let account, card: let card):
            if let account {
                return account.name
            } else if let card {
                return card.pan
            } else {
                return "PAY_TYPE".localized
            }
        }
    }
    var isInstaled: Bool {
        switch self {
        case .income(let set): return set
        case .expenses(let set): return set
        case .sum(let from, let to): return from != nil && to != nil
        case .period(let from, let to): return from != nil && to != nil
        case .operation(let type): return type != nil
        case .payedBy(let account, let card): return account != nil || card != nil
        }
    }
    var hasOptions: Bool {
        switch self {
        case .income(_): return false
        case .expenses(_): return false
        case .sum(_,_): return true
        case .period(_,_): return true
        case .operation(_): return true
        case .payedBy(_, _): return true
        }
    }
}

struct Filters: Hashable {
    var account: String?
    var amountFrom: Double?
    var amountTo: Double?
    var dateFrom: String?
    var dateTo: String?
    var expenses: Bool?
    var incoming: Bool?
    var type: Int?
}

class HistoryViewModel {
    
    class HistorySection {
        var date: Date
        var items: [AppStructs.HistoryItem]
        
        init(date: Date, items: [AppStructs.HistoryItem]) {
            self.date = date
            self.items = items
        }
    }
    
    let historyService: HistoryService
    let paymentsService: PaymentsService
    let accountInfo: AppStructs.AccountInfo
    
    var forCreditCard: AppStructs.CreditDebitCard? = nil

    var historySections: [HistorySection] = []
    var selectedHistory: AppStructs.HistoryItem? = nil
    var filters: Filters = .init()
    var entries: [AppStructs.EntryItem] = []
    var offset: Int = 0
    var isLoading: Bool = false
    
    let didHistoryUpdate = PublishSubject<Void>()
    let didLoadEntries = PublishSubject<Void>()
    let didLoadError = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    init(accountInfo: AppStructs.AccountInfo, historyService: HistoryService, paymentsService: PaymentsService) {
        self.accountInfo = accountInfo
        self.historyService = historyService
        self.paymentsService = paymentsService
    }
    
    func loadEntries() {
        self.historyService.loadEntries().observe(on: MainScheduler.instance).subscribe { entries in
            var entires = entries
            entires.insert(.init(id: -1, name: "ALL_OPERATIONS".localized), at: 0)
            self.entries = entires
            self.didLoadEntries.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func setFilters(filter: HistoryFilter) {
        self.historySections = []
        self.offset = 0
        self.didHistoryUpdate.onNext(())
        switch filter {
        case .income(let set):
            self.filters.incoming = set
        case .expenses(let set):
            self.filters.expenses = set
        case .sum(let from, let to):
            self.filters.amountFrom = from
            self.filters.amountTo = to
        case .period(let from, let to):
            if let from, let to {
                self.filters.dateFrom = DateUtils.stringFullDate(date: from)
                self.filters.dateTo = DateUtils.stringFullDate(date: to)
            } else {
                self.filters.dateFrom = nil
                self.filters.dateTo = nil
            }
        case .operation(let type):
            self.filters.type = type?.id
        case .payedBy(let account, let card):
            if let a = account {
                self.filters.account = a.account
            } else if let c = card {
                self.filters.account = String(c.id)
            }
        }
        self.getHistory()
    }
    
    func reloadHistory() {
        self.historySections = []
        self.offset = 0
        self.didHistoryUpdate.onNext(())
        self.getHistory()
    }
    
    func getHistory() {
        if self.isLoading {
            return
        }
        self.isLoading = true
        self.historyService.getHistoryItems(account: self.filters.account, amountFrom: self.filters.amountFrom, amountTo: self.filters.amountTo, dateFrom: self.filters.dateFrom, dateTo: self.filters.dateTo, expenses: self.filters.expenses, incoming: self.filters.incoming, type: self.filters.type, limit: 20, offset: self.offset).observe(on: MainScheduler.instance).subscribe { items in
            self.offset = self.offset + items.count
            self.setItems(items: items)
            self.isLoading = false
        } onFailure: { error in
            self.isLoading = false
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func setItems(items: [AppStructs.HistoryItem]) {
        var sections = [HistorySection]()
        sections.append(contentsOf: self.historySections)
        for item in items {
            guard let itemDate = item.datetime.toDate3() else { continue }
            if let lastSection = sections.last {
                if lastSection.date.isInSameDay(as: itemDate) {
                    lastSection.items.append(item)
                } else {
                    sections.append(.init(date: itemDate, items: [item]))
                }
            } else {
                sections.append(.init(date: itemDate, items: [item]))
            }
        }
        self.historySections = sections
        self.didHistoryUpdate.onNext(())
    }
}
