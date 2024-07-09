//
//  PaymentsCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 28/10/23.
//

import Foundation
import UIKit
import RxSwift

class PaymentsCoordinator: Coordinator {
    
    weak var parent: RootTabCoordinator? = nil
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    
    private var started: Bool = false
    private let bag = DisposeBag()
    
    let accountInfo: AppStructs.AccountInfo
    
    var paymentsService: PaymentsService {
        return ENVIRONMENT.isMock ? PaymentsServiceMockImpl(accountInfo: self.accountInfo) : PaymentsServiceImpl(accountInfo: self.accountInfo)
    }
    var historyService: HistoryService {
        return ENVIRONMENT.isMock ? HistoryServiceMockImpl(clientInfo: self.accountInfo.client) : HistoryServiceImpl(clientInfo: self.accountInfo.client)
    }
    var identifyService: IdentifyService {
        return ENVIRONMENT.isMock ? IdentifyServiceImpl() : IdentifyServiceImpl()
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
    }
    
    func start() {
        if !self.started {
            self.started = true
            let vc = PaymentsViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), addFavoriteMode: false, searchMode: false)
            vc.coordinator = self
            self.nav.viewControllers = [vc]
        }
    }
    
    func navigateToRootViewController() {
        self.nav.popToRootViewController(animated: true)
    }
    
    func navigateToIdentify() {
        self.nav.showProgressView()
        self.identifyService.getIdentify().subscribe(onSuccess: { [weak self] result in
            guard let self = self else { return }
            self.nav.hideProgressView()
            if result.idStatus == .inReview {
                self.nav.showErrorAlert(title: "IDENTIFICATION".localized, message: "IDEN_IN_REVIEW".localized)
            } else {
                let identifyCoor = IdentifyCoordinator(nav: self.nav, identifyService: self.identifyService, accountInfo: self.accountInfo)
                identifyCoor.navigateToStatusView(identify: result, limit: self.accountInfo.client.limit)
                self.children.append(identifyCoor)
            }
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.nav.hideProgressView()
            self.nav.showServerErrorAlert()
        }).disposed(by: self.bag)
    }
    
    func navigateToServiceGroups(paymentsOrder: PaymentsViewController.Order, paymentGroups: [AppStructs.PaymentGroup], transferTypes: [AppStructs.PaymentGroup.ServiceItem], addFavoriteMode: Bool, searchMode: Bool) {
        let vm = PaymentsViewModel(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo)
        let vc = PaymentsViewController(viewModel: vm, order: paymentsOrder, addFavoriteMode: addFavoriteMode, searchMode: searchMode)
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToServicesList(selectedGroup: AppStructs.PaymentGroup, addFavoriteMode: Bool) {
        if selectedGroup.childGroups.isEmpty {
            let vc = ServiceListViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), selectedGroup: selectedGroup, addFavoriteMode: addFavoriteMode)
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        } else {
            let vc = GroupListViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), selectedGroup: selectedGroup, addFavoriteMode: addFavoriteMode)
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToPaymentView(service: AppStructs.PaymentGroup.ServiceItem, merchant: AppStructs.Merchant?, favorite: AppStructs.Favourite?, addFavoriteMode: Bool, transferParam: String?, topupCreditCard: AppStructs.CreditDebitCard? = nil) {
        guard let transferType = AppStructs.TransferType(rawValue: service.id) else {
            if self.accountInfo.client.limit.payment || (self.accountInfo.client.limit.identifyed == .noIdentified && service.isEnabledForNotIden) {
                let vc = PaymentViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), service: service, serviceParam: transferParam, merchant: merchant, favorite: favorite, addFavoriteMode: addFavoriteMode)
                vc.coordinator = self
                self.nav.pushViewController(vc, animated: true)
            } else {
                let pro = "\("NEED_IDENTITY_FOR_PAYMENTS".localized). \("GO_IDENTITY".localized)"
                self.nav.showBooleanAlert(title: "NEED_IDENTITY_OP".localized, message: pro, okText: "IDENTIFICATION".localized) { success in
                    if success {
                        self.navigateToIdentify()
                    }
                }
            }
            return
        }
        if transferType == .transferToPhone {
            self.navigateToTransferByNumberView(transferParam: transferParam)
        } else {
            if self.accountInfo.client.limit.transfer || (self.accountInfo.client.limit.identifyed == .noIdentified && service.isEnabledForNotIden) {
                switch transferType {
                case .transferToPhone:
                    self.navigateToTransferByNumberView(transferParam: transferParam)
                case .transferToCard:
                    self.navigateToTransferByCardView()
                case .transferBetweenAccounts:
                    self.navigateToTransferAccounts(topupCreditCard: nil)
                case .transferFromForeign:
                    self.navigateToTransferForeign()
                }
            } else {
                let pro = "\("NEED_IDENTITY_FOR_TRANSFERS".localized). \("GO_IDENTITY".localized)"
                self.nav.showBooleanAlert(title: "NEED_IDENTITY_OP".localized, message: pro, okText: "IDENTIFICATION".localized) { success in
                    if success {
                        self.navigateToIdentify()
                    }
                }
            }
        }
    }
    
    func navigateToHistoryRecipe(item: AppStructs.HistoryItem) {
        let history = HistoryCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        history.parent = self.parent
        history.navigateToRecipeView(item: item)
        self.children.append(history)
    }
    
    private func navigateToTransferByNumberView(transferParam: String?) {
        let vc = TransferByNumberViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), transferParam: transferParam)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    private func navigateToTransferByCardView() {
        let vc = TransferByCardViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    private func navigateToTransferAccounts(topupCreditCard: AppStructs.CreditDebitCard?) {
        let vc = TransferByAccountsViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), topupCreditCard: topupCreditCard)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentTransferPaymentChoose(paymentCard: AppStructs.CreditDebitCard?, transfers: Bool) {
        let vc = ChooseTransferViewController(type: transfers ? .transfers : .payments, viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), paymentCreditCard: paymentCard)
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func navigateToTransferForeign() {
        let transfer = TransferCoordinator(nav: self.nav)
        transfer.navigateToTypePick()
        self.children.append(transfer)
    }
}
