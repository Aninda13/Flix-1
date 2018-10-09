//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Anthony Bravo on 9/28/18.
//  Copyright © 2018 Anthony Bravo. All rights reserved.
//

import UIKit
import AlamofireImage


class NowPlayingViewController: UIViewController, UITableViewDataSource{
    //Inherited UITableViewDataSource to use View controller as data source for table view
    
    
    @IBOutlet weak var tableView: UITableView! //table View
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! //Initial middle spinning circle
    
    var movies:[[String:Any]] = [] //Array of Dictionaries: All the movies
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        super.viewDidLoad()
        
        //Creating refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.pulledRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        self.tableView.rowHeight = 225 //Adjust the height of each cell
        fethMovies() //Get movie data
    }
    
    
    @objc func pulledRefresh(_ refreshControl:UIRefreshControl) {
        fethMovies() //Get movie data
        refreshControl.endRefreshing()
    }
    
    
    
    func fethMovies() {
        //Performing url request
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                self.tableView.reloadData() //Reloads table view after network request, to update movie count
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume() //starts the task
    }
    
    
    //2 Requirements for data source on table view: 1)How many rows 2)What to put in each row
    //1)How many rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count //Each movie gets a row = how many dictinaries we have
    }
    
    //2)Data to put in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row] //A movie from dictionary array which changes depending on where indexpath is
        let title = movie["title"] as! String  //Getting title from the dictionary of the single movie
        let overview = movie["overview"] as! String //Getting overview from the dictionary of the single movie
        
        //Changing the attributes of each of the movie cells
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let lowerUrl = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: lowerUrl+posterPathString)! //total url
        cell.posterImageView.af_setImage(withURL: posterURL) //Changing imgage attribute from MovieCell for each movie
        return cell
    }
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Sender: Who called the transition
        //Segue.Destination : Where is the transition going
        
        let detailVC = segue.destination as! MovieDetatilsViewController
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) { //row which called transition
            let movie = movies[indexPath.row]
            detailVC.movie = movie //Pass movie to detail View controller
        }
        
    }
    
    //Removes gray region of selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
