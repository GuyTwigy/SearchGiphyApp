//
//  SlideUpTableView.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit

class SlideUpTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}

