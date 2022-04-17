//
//  FullGifVC.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit

import UIKit
import ImageIOUIKit

class FullGifVC: UIViewController {

    var gifArray: [GiphyData] = []
    var index = Int()
    
    @IBOutlet weak var gifFullView: ImageSourceView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupContent() {
        gifFullView.isAnimationEnabled = true
        if let url = URL(string: gifArray[index].images.downsized_large.url) {
            gifFullView.load(url)
        }
    }
}

