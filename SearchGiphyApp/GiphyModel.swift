//
//  GiphyModel.swift
//  SearchGiphyApp
//
//  Created by Guy Twig on 18/04/2022.
//

import Foundation

import Foundation

struct GipgyResponse: Decodable {
    let data: [GiphyData]
    let pagination: Pagination
    let meta: Meta
}

struct GiphyData: Decodable {
    //    let type: String
    //    let id: String
    //    let url: String
    //    let slug: String
    //    let bitly_gif_url: String
    //    let bitily_url: String?
    //    let embed_url: String
    //    let username: String
    //    let source: String
    //    let title: String
    //    let rating: String
    //    let content_url: String
    //    let source_tld: String
    //    let source_post_url: String
    //    let is_sticker: Int
    //    let import_datetime: String
    //    let trending_datetime: String
        let images: Images
    //    let user: User?
    //    let analytics_response_payload: String
    //    let analytics: Analytics
}

struct Pagination: Decodable {
    let total_count: Int
    let count: Int
    let offset: Int
}

struct Meta: Decodable {
    let status: Int
    let msg: String
    let response_id: String
}

struct Images: Decodable {
    let original: Original
//    let downsized: Downsized
    let downsized_large: DownsizedLarge
//    let downsized_medium: DownsizedMedium?
//    let downsized_small: DownsizedSmall?
//    let downsized_still: DownsizedStill?
//    let fixed_height: FixedHeight?
//    let fixed_height_downsampled: FixedHeightDownsampled?
//    let fixed_height_small : FixedHeightSmall?
//    let fixed_height_small_still: FixedHeightSmallStill?
//    let fixed_height_still: FixedHeightStill?
//    let fixed_width: FixedWidth?
//    let fixed_width_downsampled: FixedWidthDownsampled?
//    let fixed_width_small: FixedWidthSmall?
//    let fixed_width_small_still: FixedWidthSmallStill?
//    let fixed_width_still: FixedWidthStill?
//    let looping: Looping?
//    let original_still: OriginalStill?
//    let original_mp4: OriginalMp4?
//    let preview: Preview?
//    let preview_gif: PreviewGif?
//    let preview_webp: PreviewWebp?
//    let hd: Hd?
//    let _480w_still: _480wStill?
}

struct Original: Decodable {
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

struct Downsized: Decodable {
    let height: String
    let width: String
    let size: String
    let url: String
}

struct DownsizedLarge: Decodable {
    let height: String
    let width: String
    let size: String
    let url: String
}

struct DownsizedMedium: Decodable {
    let height: String
    let width: String
    let size: String
    let url: String
}

struct DownsizedSmall: Decodable {
    let height: String
    let width: String
    let mp4_size: String
    let mp4: String
}

struct DownsizedStill: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}

struct FixedHeight: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
    let mp4_size: Int?
    let mp4: String?
    let webp_size: Int?
    let webp: String?
}

struct FixedHeightDownsampled: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
    let webp_size: Int?
    let webp: String?
}

struct FixedHeightSmall: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
    let mp4_size: Int?
    let mp4: String?
    let webp_size: Int?
    let webp: String?
}

struct FixedHeightSmallStill: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}

struct FixedHeightStill: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}

struct FixedWidth: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
    let mp4_size: Int?
    let mp4: String?
    let webp_size: Int?
    let webp: String?
}

struct FixedWidthDownsampled: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
    let webp_size: Int?
    let webp: String?
}

struct FixedWidthSmall: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
    let mp4_size: Int?
    let mp4: String?
    let webp_size: Int?
    let webp: String?
}

struct FixedWidthSmallStill: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}

struct FixedWidthStill: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}

struct Looping: Decodable {
    let mp4_size: Int?
    let mp4: String?

}

struct OriginalStill: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}

struct OriginalMp4: Decodable {
    let height: Int?
    let width: Int?
    let mp4_size: Int?
    let mp4: String?
}

struct Preview: Decodable {
    let height: Int?
    let width: Int?
    let mp4_size: Int?
    let mp4: String?
}

struct PreviewGif: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}

struct PreviewWebp: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}

struct Hd: Decodable {
    let height: Int?
    let width: Int?
    let mp4_size: Int?
    let mp4: String?
}

struct _480wStill: Decodable {
    let height: Int?
    let width: Int?
    let size: Int?
    let url: String?
}


struct User: Decodable {
    let avatar_url: String?
    let banner_image: String?
    let banner_url: String?
    let profile_url: String?
    let username: String?
    let display_name: String?
    let description: String?
    let instagram_url: String?
    let website_url: String?
    let is_verified: Bool?
}

struct Analytics: Decodable {
    let onload: Onload?
    let onclick : Onclick?
    let onsent: Onsent?
}

struct Onload: Decodable {
    let url: String?
}

struct Onclick: Decodable {
    let url: String?
}

struct Onsent: Decodable {
    let url: String?
}
