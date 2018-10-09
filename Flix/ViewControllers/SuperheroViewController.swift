//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Anthony Bravo on 10/8/18.
//  Copyright © 2018 Anthony Bravo. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine:CGFloat = 2
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5

        
        let totalCellHorizontalSpacing = layout.minimumInteritemSpacing*(cellsPerLine-1)
        
        let widthPerCell = (collectionView.frame.size.width/cellsPerLine) - (totalCellHorizontalSpacing / (cellsPerLine-1))
        
        layout.itemSize.height = (1.5)*widthPerCell //height of cell
        layout.itemSize.width = widthPerCell //width of cell

        
        fethMovies()
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        let posterPath = movie["poster_path"] as! String
        let lowerUrl = "https://image.tmdb.org/t/p/w500"
        let url  = URL(string: lowerUrl+posterPath)!
        cell.posterImageView.af_setImage(withURL: url)
        return cell
    }
    
    
    func fethMovies() {
        //Performing url request
        let url = URL(string: "https://api.themoviedb.org/3/movie/363088/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                //Parses our data from JSON to a swift dictionary where String is key and any is value
                
                let movies = dataDictionary["results"] as! [[String:Any]]
                //Array of dictionaries, each dictionary represents a movie
                
                self.movies = movies
                self.collectionView.reloadData() //Reloads table view after network request, to update movie count
                // self.activityIndicator.stopAnimating()
            }
        }
        task.resume() //starts the task
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Sender: Who called the transition
        //Segue.Destination : Where is the transition going
        
        let detailVC = segue.destination as! MovieDetatilsViewController
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) { //row which called transition
            let movie = movies[indexPath.row]
            detailVC.movie = movie //Pass movie to detail View controller
        }
        
    }
    
    
    
}
