//
//  HistoryViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift

class HistoryViewModel {
    
    struct HistorySection {
        var date: Date
        var items: [AppStructs.HistoryItem]
    }
    
    let historyService: HistoryService
    var historySections: [HistorySection] = []
    var selectedHistory: AppStructs.HistoryItem? = nil
    
    let didHistoryUpdate = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init(historyService: HistoryService) {
        self.historyService = historyService
    }
    
    func getHistory() {
        DispatchQueue.main.async {
            var sections = [HistorySection]()
            sections.append(.init(date: Date(), items: []))
            let history = self.historyService.getHistoryItems()
            for item in history.enumerated() {
                if item.offset == 5 {
                    sections.append(.init(date: Date(), items: []))
                } else if item.offset == 10 {
                    sections.append(.init(date: Date(), items: []))
                } else if item.offset == 15 {
                    sections.append(.init(date: Date(), items: []))
                } else if item.offset == 20 {
                    sections.append(.init(date: Date(), items: []))
                } else {
                    sections[sections.count - 1].items.append(.init(date: Date()))
                }
            }
            self.historySections = sections
            self.didHistoryUpdate.onNext(())
        }
    }
}
