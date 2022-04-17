//
//  ViewController.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit

class ViewController: UIViewController {

    var gifArray: [GiphyData] = []
    var pageCounter = 1
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: GifCell.nibName, bundle: nil), forCellWithReuseIdentifier: GifCell.nibName)
        getGif(search: "barcelona",pageCounter: pageCounter,firstLoad: true)
    }
    
    func getGif(search: String, pageCounter: Int, firstLoad: Bool) {
        if firstLoad {
            self.pageCounter = 1
        }
        loader.startAnimating()
        NetworkManager.shared.getGiphySearch(search: search, page: pageCounter, firstLoad: firstLoad) { result, giphy in
            guard let giphy = giphy else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if firstLoad {
                    self.gifArray = giphy
                } else {
                    self.gifArray.append(contentsOf: giphy)
                }
                self.collectionView.reloadData()
                self.loader.stopAnimating()
            }
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gifArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.nibName, for: indexPath) as! GifCell
        
        cell.gifView.isAnimationEnabled = true
        if let url = URL(string: gifArray[indexPath.row].images.original.url) {
            cell.gifView.load(url)
        }
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width) / 3.2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == gifArray.count - 1 ) {
            pageCounter += 1
            getGif(search: "barcelona", pageCounter: pageCounter, firstLoad: false)
            
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
}


