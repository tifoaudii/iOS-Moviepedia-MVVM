//
//  MovieVM.swift
//  Moviepedia
//
//  Created by Tifo Audi Alif Putra on 20/06/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation

struct MovieVM {
    
    private var movie: Movie
    
    private static let dateFormatter: DateFormatter = {
        $0.dateStyle = .medium
        $0.timeStyle = .none
        return $0
    }(DateFormatter())
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.title
    }
    
    var overview: String {
        return movie.overview
    }
    
    var posterUrl: URL {
        return movie.posterURL
    }
    
    var releaseDate: String {
        return MovieVM.dateFormatter.string(from: movie.releaseDate)
    }
    
    var rating: String {
        let rating = Int(movie.voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc,_) -> String in
            return acc + "⭐️"
        }
        
        return ratingText
    }
}
