//
//  ViewController.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit
import AVFoundation
import ImageIOUIKit

class ViewController: UIViewController {
    
    var gifArray: [GiphyData] = []
    var favArray: [GiphyData] = []
    var pageCounter = 0
    var isOn = true
    var player: AVAudioPlayer?
    var searchBarText: String = ""
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundMusicToggle: UISwitch!
    @IBOutlet weak var onOffLabel: UILabel!
    @IBOutlet weak var labelFadeOut: UILabel!
    @IBOutlet weak var fingerTapImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSound()
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: GifCell.nibName, bundle: nil), forCellWithReuseIdentifier: GifCell.nibName)
        beginingAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        searchBar.becomeFirstResponder()
        searchBar.resignFirstResponder()
        if let fav = UserDefaults.standard.favListSave {
            favArray = fav
        }
    }
    
    func getGif(search: String, pageCounter: Int, firstLoad: Bool) {
        if firstLoad {
            self.pageCounter = 0
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
    
    func setupSound() {
        let urlString = Bundle.main.path(forResource: "what_a_good_day", ofType: "mp3")
        do {
            guard let urlString = urlString else {
                print("Somthing went wrong with the audio file")
                return
            }
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            
            guard let player = player else {
                print("Something went wrong")
                return
            }
            player.play()
        } catch {
            print("Somthing went wrong with the audio")
        }
    }
    
    func beginingAnimation() {
        UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseOut, animations: {
            self.fingerTapImageView.transform = CGAffineTransform(translationX: -130, y: -225)
            self.fingerTapImageView.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
                self.fingerTapImageView.alpha = 1
            }) { _ in
                UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
                    self.fingerTapImageView.alpha = 0.5
                }) { _ in
                    UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
                        self.fingerTapImageView.alpha = 1
                        self.labelFadeOut.alpha = 0
                    }) { _ in
                        UIView.animate(withDuration: 2.5, delay: 1.5, options: .curveEaseOut, animations: {
                            self.fingerTapImageView.alpha = 0
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func favButtonTapped(_ sender: Any) {
        let FavVC = FavoriteGifList()
        navigationController?.pushViewController(FavVC, animated: true)
    }
    
    @IBAction func toggleMusic(_ sender: Any) {
        isOn = !isOn
        if backgroundMusicToggle.isOn {
            // playMusic
            onOffLabel.text = "On"
            backgroundMusicToggle.setOn(isOn, animated: true)
            if let player = player, !player.isPlaying {
                player.play()
            }
        } else {
            // dontPlay
            onOffLabel.text = "Off"
            backgroundMusicToggle.setOn(isOn, animated: true)
            if let player = player, player.isPlaying {
                player.stop()
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
        cell.gifArray = gifArray
        cell.index = indexPath.row
        cell.setupContent()
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width) / 3.2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullGifVC = FullGifVC()
        fullGifVC.gifArray = gifArray
        fullGifVC.index = indexPath.row
        fullGifVC.delegate = self
        fullGifVC.state = .fromSearch
        navigationController?.pushViewController(fullGifVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == gifArray.count - 1) {
            pageCounter += 1
            getGif(search: searchBarText, pageCounter: pageCounter, firstLoad: false)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fingerTapImageView.isHidden = true
        labelFadeOut.isHidden = true
        if searchText.count > 2 {
            let string =  searchText
            if let string = string.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed){
                searchBarText = string
            }
            getGif(search: searchBarText,pageCounter: pageCounter,firstLoad: true)
        }
    }
}

extension ViewController: FullGifVCDelegate {
    func updateFavArray(favArray: [GiphyData]) {
        self.favArray = favArray
        UserDefaults.standard.favListSave = favArray
    }
}
