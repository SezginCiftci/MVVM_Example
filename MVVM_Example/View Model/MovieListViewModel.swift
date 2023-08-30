//
//  MainViewModel.swift
//  MVVM_Example
//
//  Created by Sezgin on 31.03.2022.
//

import UIKit

@MainActor
class MovieListViewModel {
    
    private let service = Webservice()
    var movies: MovieListModel?
    
    public var movieTitles = [String]()
    
    public func loadMovieList(_ completion: @escaping() -> ()) {
        guard let url = URL(string: Constants.baseUrl+Constants.apiKey) else { return }
        let resource = Resource<MovieListModel>(url: url)
        
        Task {
            let movies = await service.fetchMovies(resource: resource)
            switch movies {
            case .success(let movies):
                self.movies = movies
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}


