//
//  FullGifVC.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import UIKit
import ImageIOUIKit

class FullGifVC: UIViewController {
    
    var gifArray: [GiphyData] = []
    var index = Int()
    let aboveView = UIView()
    let tableView = SlideUpTableView()
    let tableViewHeight: CGFloat = 270.0
    let slideUpRows = ["Save gif to camera roll", "Save gif to Favorite List", "Share gif", "My favorite List"]
    
    @IBOutlet weak var gifFullView: ImageSourceView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupTableView()
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
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.aboveView.isHidden = false
            self.aboveView.alpha = 0.7
            self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.tableViewHeight, width: screenSize.width, height: self.tableViewHeight)
        }, completion: nil)
    }
    
    @objc func tappedOutsideTableView() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.aboveView.isHidden = true
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.tableViewHeight)
        }, completion: nil)
    }
}


extension FullGifVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        slideUpRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SlideUpCell.nibName, for: indexPath) as! SlideUpCell
        cell.titleLabel.text = slideUpRows[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let url = URL(string: gifArray[index].images.downsized_large.url) else {
                return
            }
            
            
            
        }
    }
}
