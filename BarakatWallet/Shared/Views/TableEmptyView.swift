//
//  TableEmptyView.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

public class TableEmptyView: PaddingLabel {
    
    public init(size: CGSize, labelMessage: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.leftInset = 20
        self.rightInset = 20
        self.text = labelMessage
        self.font = UIFont.semibold(size: 20)
        self.textColor = UIColor.gray
        self.numberOfLines = 0
        self.textAlignment = .center
        self.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
