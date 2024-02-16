//
//  CardItemCell.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

protocol CardItemCellDelegate: AnyObject {
    func copyInfo(cell: CardItemCell, number: Bool, date: Bool, cvv: Bool)
}

class CardItemCell: UICollectionViewCell, CardViewDelegate {
   
    let cardView: CardView = {
        let view = CardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    weak var delegate: CardItemCellDelegate?
    
    override var isHighlighted: Bool {
        didSet {
            self.cardView.alpha = self.isHighlighted ? 0.5 : 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.cardView)
        NSLayoutConstraint.activate([
            self.cardView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.cardView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(card: AppStructs.CreditDebitCard, show: Bool, showCopy: Bool, selectedColor: (start: UIColor, end: UIColor)? = nil) {
        self.cardView.delegate = self
        self.cardView.configure(card: card, show: show, showCopy: showCopy, selectedColor: selectedColor)
    }
    
    func copyInfo(cardView: CardView, number: Bool, date: Bool, cvv: Bool) {
        self.delegate?.copyInfo(cell: self, number: number, date: date, cvv: cvv)
    }
}
