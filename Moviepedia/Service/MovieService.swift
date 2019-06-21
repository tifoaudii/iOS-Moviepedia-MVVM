//
//  MovieService.swift
//  Moviepedia
//
//  Created by Tifo Audi Alif Putra on 20/06/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import Foundation

class MovieService {
    
    static let instance = MovieService()
    private let apiKey = "ae5b867ee790efe19598ff6108ad4e02"
    private let baseUrl = "https://api.themoviedb.org/3/movie/top_rated"
    private let searchUrl = "https://api.themoviedb.org/3/search/movie"
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    func fetchTrendingMovies(completion: @escaping(_ movies: MoviesResponse)-> Void, errorHandler: @escaping(_ error: Error)->Void) {
        
        var urlComponent = URLComponents(string: baseUrl)
        urlComponent?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        let urlEndpoint = urlComponent?.url
        urlSession.dataTask(with: urlEndpoint!) { (data, response, error) in
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
                let moviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(moviesResponse)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
        }.resume()
    }
    
    func searchMovie(query: String, params: [String : String]?, successHandler: @escaping (MoviesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        var urlComponents = URLComponents(string: searchUrl)
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                          URLQueryItem(name: "language", value: "en-US"),
                          URLQueryItem(name: "include_adult", value: "false"),
                          URLQueryItem(name: "query", value: query)
        ]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            errorHandler(MovieError.invalidEndpoint)
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
                let moviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    successHandler(moviesResponse)
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



public enum MovieError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
