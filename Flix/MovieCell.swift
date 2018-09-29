//
//  MovieCell.swift
//  Flix
//
//  Created by Anthony Bravo on 9/29/18.
//  Copyright © 2018 Anthony Bravo. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! //Title of Movie
    @IBOutlet weak var overviewLabel: UILabel! //Overview of Movie
    @IBOutlet weak var posterImageView: UIImageView! //Picture of the movie
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
