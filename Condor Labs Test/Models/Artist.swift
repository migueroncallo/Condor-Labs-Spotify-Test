//
//  Artist.swift
//  Condor Labs Test
//
//  Created by Miguel Roncallo on 8/1/19.
//  Copyright © 2019 Miguel Roncallo. All rights reserved.
//

import Foundation

struct ArtistRoot: Codable{
    var artists: ArtistItem
}

struct ArtistItem: Codable{
    var items: [Artist]
}

struct Artist: Codable{
    var name: String
    var popularity: Int
    var id: String
    var followers: ArtistFollowers
    var images: [ArtistImage]
}

struct ArtistImage: Codable{
    var height: Int
    var width: Int
    var url: String
}

struct ArtistFollowers: Codable{
    var total: Int
}
