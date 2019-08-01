//
//  Token.swift
//  Condor Labs Test
//
//  Created by Miguel Roncallo on 8/1/19.
//  Copyright © 2019 Miguel Roncallo. All rights reserved.
//

import Foundation

struct AuthToken: Codable{
    var token: String
    
    private enum tokenCodingkeys: String, CodingKey{
        case token = "access_token"
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: tokenCodingkeys.self)
        token = try container.decode(String.self, forKey: .token)
    }
}
