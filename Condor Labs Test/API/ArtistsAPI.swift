//
//  ArtistsAPI.swift
//  Condor Labs Test
//
//  Created by Miguel Roncallo on 8/1/19.
//  Copyright © 2019 Miguel Roncallo. All rights reserved.
//

import Foundation
import Alamofire

class ArtistsAPI{
    static let shared = ArtistsAPI()
    var authToken = ""
    
    func getAuthToken(_ cb: @escaping(Bool)->()){
        let credentialData = "\(clientId):\(clientSecret)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = [
            "Authorization": "Basic \(base64Credentials)"
        ]
        let params = [
            "grant_type": "client_credentials"
        ]
        
        Alamofire.request(tokenURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success:
                    let decoder = JSONDecoder()
                    let token = try! decoder.decode(AuthToken.self, from: response.data!)
                    self.authToken = token.token
                    cb(true)
                case .failure(let error):
                    print(error)
                    cb(false)
                }
                
        }
    }
    
    func searchArtist(q: String, _ cb: @escaping(Error?, Artist?)->()){
        
        let url = "\(baseURL)search"
        getAuthToken { (success) in
            if success{
                let params = [
                    "q": q,
                    "type": "artist",
                    "limit": 1
                    ] as [String: Any]
                
                let headers = [
                    "Authorization": "Bearer \(self.authToken)"
                ]
                
                Alamofire.request(url, method: .get, parameters: params, headers: headers)
                    .validate()
                    .responseJSON { (response) in
                        switch response.result{
                        case .success:
                            let decoder = JSONDecoder()
                            let artist = try! decoder.decode(ArtistRoot.self, from: response.data!)
                            cb(nil, artist.artists.items[0])
                            
                        case .failure(let error):
                            cb(error, nil)
                        }
                }
            }else{
                let error = NSError(domain: "Failed to get token", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid access token"])
                
                cb(error as Error, nil)
            }
            
        }
    }
    
    func getArtistAlbums(artistId: String, _ cb: @escaping(Error?, [Album]?) ->()){
        let url = "\(baseURL)artists/\(artistId)/albums"
        
        getAuthToken { (success) in
            if success{
                let headers = [
                    "Authorization": "Bearer \(self.authToken)"
                ]
                
                Alamofire.request(url, method: .get, headers: headers)
                .validate()
                    .responseJSON(completionHandler: { (response) in
                        switch response.result{
                        case .success:
                            let decoder = JSONDecoder()
                            let albums = try! decoder.decode(AlbumRoot.self, from: response.data!)
                            cb(nil, albums.items)
                            
                        case .failure(let error):
                            cb(error, nil)
                        }
                    })
                
            }else{
                let error = NSError(domain: "Failed to get token", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid access token"])
                
                cb(error as Error, nil)
            }
        }
        
        
        
        
        
    }
}
