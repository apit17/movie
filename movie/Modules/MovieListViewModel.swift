//
//  MovieListViewModel.swift
//  movie
//
//  Created by Apit Gilang Aprida on 3/5/21.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewViewModel {
    private let movieService: MovieService
    private let disposeBag = DisposeBag()
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    var numberOfMovies: Int {
        return _movies.value.count
    }
    
    init(movieService: MovieService) {
        self.movieService = movieService
        fetchMovies()
    }
    
    func viewModelForMovie(at index: Int) -> MovieViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        return MovieViewModel(movie: _movies.value[index])
    }
    
    func fetchMovies() {
        self._movies.accept([])
        self._isFetching.accept(true)
        self._error.accept(nil)
        movieService.fetchMovies(successHandler: {[weak self] (response) in
            self?._isFetching.accept(false)
            self?._movies.accept(response)
        }) { [weak self] (error) in
            self?._isFetching.accept(false)
            self?._error.accept(error.localizedDescription)
        }
    }
    
}
