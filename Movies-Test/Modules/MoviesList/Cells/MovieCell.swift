//
//  MovieCell.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var imageViewMovie: UIImageView!
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(name: String, releaseDate: String, image: String) {
        labelMovieName.text = name
        labelReleaseDate.text = releaseDate
        if let url = URL(string: moviePosterRoot + image) {
            imageViewMovie.kf.setImage(with: url)
        }
    }
}
