//
//  AlbumDetailViewController.swift
//  Condor Labs Test
//
//  Created by Miguel Roncallo on 8/1/19.
//  Copyright © 2019 Miguel Roncallo. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class AlbumDetailViewController: UIViewController {

    //MARK: - Variables
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    var album: Album
    
    //MARK: - Initializer
    
    init(album: Album) {
        self.album = album
        super.init(nibName: String(describing: AlbumDetailViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        condigAlbumInfo()
    }
    
    //MARK: - IBActions
    
    @IBAction func openAlbumDetail(_ sender: UIButton) {
        let url = URL(string: album.external_urls.spotify)!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
    }
    
    //MARK: - Internal helpers
    
    func condigAlbumInfo(){
        if album.images.count > 0{
            let url = URL(string: album.images[0].url)
            albumImageView.kf.setImage(with: url)
        }
        
        albumNameLabel.text = album.name
    }
}

extension AlbumDetailViewController: SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
