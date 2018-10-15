//
//  MovieDetatilsViewController.swift
//  Flix
//
//  Created by Anthony Bravo on 10/7/18.
//  Copyright © 2018 Anthony Bravo. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetatilsViewController: UIViewController {


    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie : [String:Any]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Checks if we have a movie
        if let movie = self.movie {
            titleLabel.text = movie["title"] as? String
            dateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            overviewLabel.sizeToFit();
            
            //end url
            let backDropImageEndPath = movie["backdrop_path"] as! String
            let posterImageEndPath = movie["poster_path"] as! String
            //front url
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            
            let backDropURL = URL(string: baseUrl+backDropImageEndPath)!
            backDropImageView.af_setImage(withURL: backDropURL)
            
            let posterURL = URL(string: baseUrl+posterImageEndPath)!
            posterImageView.af_setImage(withURL: posterURL)
            
            
            
        }

    }
    

}
