//
//  SearchViewController.swift
//  Condor Labs Test
//
//  Created by Miguel Roncallo on 8/1/19.
//  Copyright © 2019 Miguel Roncallo. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class SearchViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: - Variables
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var popularityLabel: UILabel!
    
    @IBOutlet weak var artistImageView: UIImageView!
    
    @IBOutlet weak var albumsTableView: UITableView!
    
    @IBOutlet weak var tableViewTitleLabel: UILabel!
    
    
    var albums = [Album]()
    
    //MARK: - Initializer
    
    init() {
        super.init(nibName: String(describing: SearchViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleViews(hide: true)
        configTableView()
        searchBar.delegate = self
    }
    
    //MARK: - Internal helpers
    
    func configTableView(){
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        albumsTableView.tableFooterView = UIView()
        albumsTableView.register(UINib(nibName: String(describing: AlbumsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AlbumsTableViewCell.self))
        albumsTableView.rowHeight = UITableView.automaticDimension
        albumsTableView.estimatedRowHeight = 99
    }
    
    func loadData(q: String){
        startAnimating()
        ArtistsAPI.shared.searchArtist(q: q) { (error, artist) in
            
            if let a = artist{
                self.configArtistInfo(artist: a)
                ArtistsAPI.shared.getArtistAlbums(artistId: a.id, { (albumError, albums) in
                    self.stopAnimating()
                    if let albums = albums{
                        self.toggleViews(hide: false)
                        self.albums = albums
                        print(albums)
                        self.albumsTableView.reloadData()
                    }else{
                        print("Error loading albums")
                    }
                })
            }else{
                self.stopAnimating()
                print("Error loading artist")
            }
        }
    }
    
    func configArtistInfo(artist: Artist){
        artistNameLabel.text = artist.name
        followersLabel.text = "\(artist.followers.total) followers"
        popularityLabel.text = "\(artist.popularity)/100 ⭐️"
        if artist.images.count > 0{
            let url = URL(string: artist.images[0].url)
            artistImageView.kf.setImage(with: url)
        }
        print("Artist id: \(artist.id)")
    }
    
    func toggleViews(hide: Bool){
        artistNameLabel.isHidden = hide
        followersLabel.isHidden = hide
        popularityLabel.isHidden = hide
        artistImageView.isHidden = hide
        albumsTableView.isHidden = hide
        tableViewTitleLabel.isHidden = hide
    }
    
}

//MARK: - UITableViewDataSource protocol conformance
extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AlbumsTableViewCell.self)) as! AlbumsTableViewCell
        
        cell.configCell(album: albums[indexPath.row])
        
        return cell
    }
}
//MARK: - UITableViewDelegate protocol conformance
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = albums[indexPath.row]
        let albumDetailVC = AlbumDetailViewController.init(album: selectedAlbum)
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}

//MARK: - UISearchBarDelegate protocol conformance
extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
        self.toggleViews(hide: true)
        if searchBar.text!.isEmpty{ return }else{
            albums.removeAll()
            let query = searchBar.text!
            loadData(q: query)
        }
    }
}
