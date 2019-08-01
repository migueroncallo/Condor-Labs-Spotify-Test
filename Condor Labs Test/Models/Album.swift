//
//  Album.swift
//  Condor Labs Test
//
//  Created by Miguel Roncallo on 8/1/19.
//  Copyright © 2019 Miguel Roncallo. All rights reserved.
//

import Foundation

struct AlbumRoot: Codable{
    var items: [Album]
}
struct Album: Codable{
    var name: String
    var id: String
    var available_markets: [String]
    var images: [AlbumImage]
    var external_urls: ExternalUrl
}

struct AlbumImage: Codable{
    var height: Int
    var width: Int
    var url: String
}

struct ExternalUrl: Codable{
    var spotify: String
}
