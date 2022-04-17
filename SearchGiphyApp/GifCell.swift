//
//  GifCell.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit
import ImageIOUIKit

class GifCell: UICollectionViewCell {
    
    static let nibName = "GifCell"
    var gifArray: [GiphyData] = []
    var index = Int()
    
    @IBOutlet weak var gifView: ImageSourceView!
    
    func setupContent() {
        gifView.isAnimationEnabled = true
        if let url = URL(string: gifArray[index].images.original.url) {
            gifView.load(url)
        }
    }
}
