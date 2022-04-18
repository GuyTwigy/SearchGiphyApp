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
    let height: String
    let width: String
    let size: String
    let url: String
    let mp4_size: String
    let mp4: String
    let webp_size: String
    let webp: String
    let frames: String
    let hash: String
}

struct DownsizedLarge: Codable {
    let height: String
    let width: String
    let size: String
    let url: String
}
