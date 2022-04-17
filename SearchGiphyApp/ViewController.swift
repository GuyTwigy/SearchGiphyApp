//
//  ViewController.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var gifArray: [GiphyData] = []
    var pageCounter = 1
    var isOn = true
    var player: AVAudioPlayer?
    var searchBarText: String = ""
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backgroundMusicToggle: UISwitch!
    @IBOutlet weak var onOffLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSound()
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: GifCell.nibName, bundle: nil), forCellWithReuseIdentifier: GifCell.nibName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    func setupSound() {
        let urlString = Bundle.main.path(forResource: "Time_Hans_Zimmer_Inception", ofType: "mp3")
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
        if searchText.count > 2 {
            searchBarText = searchText
            getGif(search: searchBarText,pageCounter: pageCounter,firstLoad: true)
        }
    }
}


