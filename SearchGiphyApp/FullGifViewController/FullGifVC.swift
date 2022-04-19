//
//  FullGifVC.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit
import ImageIOUIKit
import Photos
import AssetsLibrary

protocol FullGifVCDelegate {
    func updateFavArray(favArray: [GiphyData])
}

class FullGifVC: UIViewController {
        
    enum State {
        case fromSearch
        case fromFav
    }
    
    var gifArray: [GiphyData] = []
    var favArray: [GiphyData] = []
    var index = Int()
    var indexFav = Int()
    let aboveView = UIView()
    let tableView = SlideUpTableView()
    let screenSize = UIScreen.main.bounds.size
    var tableViewHeight = CGFloat()
    let cellHeight: CGFloat = 60
    var urlString = String()
    var slideUpRowsArray: [String] = []
    var delegate: FullGifVCDelegate?
    var state: State?
    
    @IBOutlet weak var gifFullView: ImageSourceView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var fadeOutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fav = UserDefaults.standard.favListSave {
            favArray = fav
        }
        setupContent()
        setupTableView()
        fadeOutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupContent() {
        fadeOutLabel.layer.cornerRadius = 10
        fadeOutLabel.text = "Tap on Gif for\n more options"
        gifFullView.isAnimationEnabled = true
        switch state {
        case .fromSearch:
            slideUpRowsArray = ["Save gif to camera roll", "Share gif", "Save gif to Favorite List", "My favorite List"]
            if let url = URL(string: gifArray[index].images.downsized_large.url) {
                gifFullView.load(url)
            }
            urlString = gifArray[index].images.original.url
            tableViewHeight = 290
        case .fromFav:
            slideUpRowsArray = ["Save gif to camera roll", "Share gif", "Remove from list"]
            if let url = URL(string: favArray[indexFav].images.downsized_large.url) {
                gifFullView.load(url)
            }
            urlString = favArray[indexFav].images.original.url
            tableViewHeight = 230
        case .none:
            break
        }
        let tapGifView = UITapGestureRecognizer(target: self, action: #selector(gifTapped))
        gifFullView.addGestureRecognizer(tapGifView)
    }
    
    func setupTableView() {
        tableView.backgroundColor = .systemYellow
        tableView.layer.cornerRadius = 15
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: SlideUpCell.nibName, bundle: nil), forCellReuseIdentifier: SlideUpCell.nibName)
    }
    
    @objc func gifTapped() {
        aboveView.frame = self.view.frame
        self.aboveView.backgroundColor = .black
        view.addSubview(aboveView)
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: tableViewHeight)
        view.addSubview(tableView)
        
        let removeTableView = UITapGestureRecognizer(target: self, action: #selector(tappedOutsideTableView))
        aboveView.addGestureRecognizer(removeTableView)
        
        showSlideUp()
    }
    
    func dismissSlideup() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { [self] in
            self.aboveView.isHidden = true
            self.tableView.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.tableViewHeight)
        }, completion: nil)
    }
    
    func showSlideUp() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.aboveView.isHidden = false
            self.aboveView.alpha = 0.7
            self.tableView.frame = CGRect(x: 0, y: self.screenSize.height - self.tableViewHeight, width: self.screenSize.width, height: self.tableViewHeight)
        }, completion: nil)
    }
    
    @objc func tappedOutsideTableView() {
        dismissSlideup()
    }
    
    func fadeOutView() {
        UIView.animate(withDuration: 2, delay: 2, options: .curveEaseOut, animations: {
            self.fadeOutLabel.alpha = 0
        })
    }
    
    func saveToCameraRoll() {
        if let shareURL = NSURL(string: urlString), let shareData = NSData(contentsOf: shareURL as URL) {
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: shareData as Data, options: nil)
            })
            dismissSlideup()
            presentAlert(withTitle: "Successfully saved to camera roll", message: "💪💪💪")
            loader.stopAnimating()
        }
    }

    func shareGif() {
        if let shareURL = NSURL(string: urlString), let shareData = NSData(contentsOf: shareURL as URL) {
            let firstActivityItem: Array = [shareData]
            let activityViewController = UIActivityViewController(activityItems: firstActivityItem, applicationActivities: nil)
            dismissSlideup()
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func addOrRemoveItem() {
        switch state {
        case .fromSearch:
            if !favArray.contains(where: {$0.images.original.url == gifArray[index].images.original.url}) {
                favArray.append(gifArray[index])
                UserDefaults.standard.favListSave = favArray
                delegate?.updateFavArray(favArray: favArray)
                dismissSlideup()
                presentAlert(withTitle: "You Added the gif Successfully", message: "Check your Favorite list 🥇" )
            } else {
                presentAlert(withTitle: "This gif is already in Favorite list", message: "")
            }
        case .fromFav:
            if favArray.contains(where: {$0.images.original.url == urlString}) {
                presentAlertWithAction(withTitle: "Are you sure?? ", message: "By clicking OK the gif will be removed from list.", complition: {
                    self.favArray.remove(at: self.indexFav)
                    UserDefaults.standard.favListSave = self.favArray
                    self.dismissSlideup()
                    self.presentAlert(withTitle: "You removed the gif Successfully", message: "")
                })
            } else {
                presentAlert(withTitle: "This gif is not longer is list", message: "You can search and add it again.")
            }
        case .none:
            break
        }
    }
}


extension FullGifVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        slideUpRowsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SlideUpCell.nibName, for: indexPath) as! SlideUpCell
        cell.titleLabel.text = slideUpRowsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            loader.startAnimating()
            saveToCameraRoll()
        }
        if indexPath.row == 1 {
            shareGif()
        }
        if indexPath.row == 2 {
            addOrRemoveItem()
        }
        if indexPath.row == 3 {
            let FavVC = FavoriteGifList()
            navigationController?.pushViewController(FavVC, animated: true)
        }
    }
}
