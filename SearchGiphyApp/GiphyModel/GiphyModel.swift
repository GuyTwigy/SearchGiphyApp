//
//  GiphyModel.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import Foundation

struct GipgyResponse: Codable {
    let data: [GiphyData]
    let pagination: Pagination
    let meta: Meta
}

struct GiphyData: Codable {
    let images: Images
}

struct Pagination: Codable {
    let total_count: Int
    let count: Int
    let offset: Int
}

struct Meta: Codable {
    let status: Int
    let msg: String
    let response_id: String
}

struct Images: Codable {
    let original: Original
    let downsized_large: DownsizedLarge
}

struct Original: Codable {
    let url: String
}

struct DownsizedLarge: Codable {
    let url: String
}
