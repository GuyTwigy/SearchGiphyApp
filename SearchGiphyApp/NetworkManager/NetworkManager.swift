//
//  NetworkManager.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import Foundation

class NetworkManager {

    static var shared = NetworkManager()
    var baseUrl = "https://api.giphy.com/v1/gifs/search"
    
    func getGiphySearch(search: String, page: Int = 0, firstLoad: Bool, callBack: @escaping (Bool, [GiphyData]?) -> Void) {
        let apiKey = "?api_key=WzrHZBIvMMkvAcdAy9nu0LNsWp8vgo8f"
        let gifQuery = "&q=\(search)"
        let paginationCounter = "&offset=\(page)"
        let fullUrl = baseUrl + apiKey + gifQuery + paginationCounter
        
        guard let url = URL(string: fullUrl) else {
            print("Failed to load gif")
            return callBack(false, nil)
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Failed to load gif")
                return callBack(false, nil)
            }
            do {
                let response = try JSONDecoder().decode(GipgyResponse.self, from: data)
                callBack(true, response.data)
            } catch {
                print("Failed to load gif")
                callBack(false, nil)
            }
        }
        task.resume()
    }
}

