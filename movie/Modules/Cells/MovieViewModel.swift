//
//  MovieViewModel.swift
//  movie
//
//  Created by Apit Gilang Aprida on 3/5/21.
//

import Foundation

struct MovieViewModel {
    
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        return movie.title
    }
    var description: String {
        return movie.description
    }
    var director: String {
        return movie.director
    }
    var releaseDate: String {
        return movie.release_date
    }
    
}
