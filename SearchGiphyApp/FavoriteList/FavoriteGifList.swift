//
//  FavoriteGifList.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit

class FavoriteGifList: UIViewController {
    
    var favArray: [GiphyData] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove All 🚮", style: .plain, target: self, action: #selector(removeAllFavorites))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: GifCell.nibName, bundle: nil), forCellWithReuseIdentifier: GifCell.nibName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if let fav = UserDefaults.standard.favListSave {
            favArray = fav
        }
        if favArray.isEmpty {
            collectionView.isHidden = true
            emptyListLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            emptyListLabel.isHidden = true
        }
        collectionView.reloadData()
    }
    
    @objc func removeAllFavorites() {
        if favArray.isEmpty {
            presentAlert(withTitle: "Favorite list is empty", message: "Nothing to remove")
        } else {
            presentAlertWithAction(withTitle: "Are you sure???", message: "All your favorites gif will be lost.", complition: {
                self.favArray.removeAll()
                UserDefaults.standard.favListSave = self.favArray
                self.collectionView.reloadData()
                self.emptyListLabel.isHidden = false
            })
        }
    }
}

extension FavoriteGifList: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.nibName, for: indexPath) as! GifCell
        cell.gifArray = favArray
        cell.index = indexPath.row
        cell.setupContent()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullGifVC = FullGifVC()
        fullGifVC.indexFav = indexPath.row
        fullGifVC.state = .fromFav
        navigationController?.pushViewController(fullGifVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width) / 3.2
        return CGSize(width: width, height: width)
    }
}
