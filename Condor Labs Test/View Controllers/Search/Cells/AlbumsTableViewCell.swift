//
//  AlbumsTableViewCell.swift
//  Condor Labs Test
//
//  Created by Miguel Roncallo on 8/1/19.
//  Copyright © 2019 Miguel Roncallo. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumsTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    
    
    @IBOutlet weak var albumImageview: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var availableLabel: UILabel!
    
    @IBOutlet weak var countriesListingLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Internal Helpers
    
    func configCell(album: Album){
        if album.images.count > 0 {
            let url = URL(string: album.images[0].url)
            albumImageview.kf.setImage(with: url)
        }
        albumNameLabel.text = album.name
        if album.available_markets.count > 5{
            availableLabel.isHidden = true
            countriesListingLabel.isHidden = true
        }else{
            availableLabel.isHidden = false
            countriesListingLabel.isHidden = false
            var countriesList = ""
            for country in album.available_markets{
                countriesList += "\(country) "
            }
            countriesListingLabel.text = countriesList
        }
    }
    
    
    
}
