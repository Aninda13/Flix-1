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

    //"Main Function"
    override func viewDidLoad() {
        activityIndicator.startAnimating() //Display middle spinning circle
        super.viewDidLoad()
        
      //Creating refresh control: top spining circle when pulled down
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.pulledRefresh(_:)), for: .valueChanged)
        //Notifies the view controlller when pulled down and calls pulledRefresh method to tell it what to do
        //Note that withing the pulled refresh method the object refresh control gets passed in
        tableView.insertSubview(refreshControl, at: 0)
        //Puts the spinning circle at the top of the screen, row 0
        
        tableView.dataSource = self
        //The view controller is providing the data sourcce for the table View: We had to define methods 1) & 2)
        self.tableView.rowHeight = 225 //Adjust the height of each cell
        fethMovies() //Get movie data
    }
    
    
    @objc func pulledRefresh(_ refreshControl:UIRefreshControl) {
        fethMovies() //Get movie data
        refreshControl.endRefreshing()
        //After data is obtained, stop top spinning circle
    }
    
    
    
    func fethMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        // url represents the location of our data website as a URL object which was initialized with the address of the website as a String
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        //makes a request to the url and waits 10 seconds for a response
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        //Coordinates all of our network request
        let task = session.dataTask(with: request) { (data, response, error) in
        //gets data from the Url and returns with 3 parameters : data, response & error
        //Nerwork request has returned: check if we got any errors
            if let error = error { //if error = nil => continure to else no errors found, if error != nil assign it to error and execute if since error found
                print(error.localizedDescription)
            }
            else if let data = data { // if data != nil then we execute it, since there is content in data, if there was nothing then we skip
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                //Parses our data from JSON to a swift dictionary where String is key and any is value
                // Try means that we are avoiding the do{} try() way , which helps when handling errors
                
                let movies = dataDictionary["results"] as! [[String:Any]]
                //Array of dictionaries, each dictionary represents a movie
                
                self.movies = movies //Assign it to member variable self.movies : to use for movie count
                self.tableView.reloadData() //Reloads table view after network request, to update movie count
                
                usleep(400000)
                self.activityIndicator.stopAnimating()
                //Stop middle spinning circle
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
        //cell that has information
        //The initial cell had an identifier of : MovieCell so we are making reference to that cell and "modeling" all of our cells from that
        //Each cell is an instace of MovieCell which has attributes to change the title and description
        //Index path tells us the row "cell" that we are on, fx: first cell = 0 ..... number of rows which we defined
        //Idea: We have an array of dictionaries d[0....movie count], each element holds a movie
        //We can use indexPath to make a reference to our dictionary movie so we can connect the row that we are on to the movie which we are
        //referring to. The size of the dictionary array is the same as the # of rows in our table view. So each row gets its own movie
        
        let movie = movies[indexPath.row] //A movie from dictionary array which changes depending on where indexpath is
        let title = movie["title"] as! String  //Getting title from the dictionary of the single movie
        let overview = movie["overview"] as! String //Getting overview from the dictionary of the single movie
        
        //Changing the attributes of each of the movie cells
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String //Post url for image
        let lowerUrl = "https://image.tmdb.org/t/p/w500" // Pre url for image
        let posterURL = URL(string: lowerUrl+posterPathString)! //total url
        cell.posterImageView.af_setImage(withURL: posterURL) //Changing imgage attribute from MovieCell for each movie
        //Function is from Almofireimage pod
        return cell //Our lay out for each cell, just with different attributes
    }


}
