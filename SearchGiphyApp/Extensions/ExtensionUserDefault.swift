//
//  ExtensionUserDefault.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import Foundation

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case favListSave
    }
    
    var favListSave: [GiphyData]? {
        get {
            if let data = object(forKey: UserDefaultsKeys.favListSave.rawValue) as? Data {
                let list = try? JSONDecoder().decode([GiphyData].self, from: data)
                return list
            }
            return nil
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            setValue(data, forKey: UserDefaultsKeys.favListSave.rawValue)
        }
    }
}
