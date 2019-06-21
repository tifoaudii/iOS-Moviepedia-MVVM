//
//  MovieCell.swift
//  Moviepedia
//
//  Created by Tifo Audi Alif Putra on 20/06/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterUrl: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var overviewMovie: UILabel!
    @IBOutlet weak var dateMovie: UILabel!
    @IBOutlet weak var ratingMovie: UILabel!
    
    func setupCell(viewmodel: MovieVM) {
        self.posterUrl.kf.setImage(with: viewmodel.posterUrl)
        self.titleMovie.text = viewmodel.title
        self.overviewMovie.text = viewmodel.overview
        self.dateMovie.text = viewmodel.releaseDate
        self.ratingMovie.text = viewmodel.rating
    }
    
}
