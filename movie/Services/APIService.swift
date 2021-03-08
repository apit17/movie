//
//  APIService.swift
//  movie
//
//  Created by Apit Gilang Aprida on 3/5/21.
//

import Foundation
import RxSwift

protocol MovieRepository {
    func fetchMovies(successHandler: @escaping (_ response: [Movie]) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
}

class MovieService: MovieRepository {
    
    static let shared = MovieService()
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
        return jsonDecoder
    }()
    
    func fetchMovies(successHandler: @escaping (_ response: [Movie]) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
        guard let url = URL(string: "https://ghibliapi.herokuapp.com/films") else {
            handleError(errorHandler: errorHandler, error: MovieError.invalidEndpoint)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)

                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let movie = try self.jsonDecoder.decode([Movie].self, from: data)
                DispatchQueue.main.async {
                    successHandler(movie)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
        }.resume()
    
    }
    
    private func handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
        DispatchQueue.main.async {
            errorHandler(error)
        }
    }
    
}

enum MovieError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
