//
//  UICollectionViewExt.swift
//  BarakatWallet
//
//  Created by km1tj on 05/12/23.
//

import Foundation
import UIKit

extension UICollectionView {
    public func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
          x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
          y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
}

extension UITableView {
    public func reloadDataAndKeepOffset() {
        // stop scrolling
        //let oldTableViewHeight = self.contentSize.height
        //setContentOffset(contentOffset, animated: false)
        // calculate the offset and reloadData
        //let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        //let newTableViewHeight = self.contentSize.height
        //self.setContentOffset(.init(x: 0, y: newTableViewHeight - oldTableViewHeight), animated: false)
//        let afterContentSize = contentSize
//        // reset the contentOffset after data is updated
//        let newOffset = CGPoint(x: 0, y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
//        setContentOffset(newOffset, animated: false)
    }
}
