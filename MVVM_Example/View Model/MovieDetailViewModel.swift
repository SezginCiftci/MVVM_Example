//
//  MovieDetailViewModel.swift
//  MVVM_Example
//
//  Created by Sezgin on 2.04.2022.
//

import Foundation
import UIKit

@MainActor
class MovieDetailViewModel {
        
    private var service = Webservice()
    public var details: MovieDetailModel?
    
    private var genreNames: [String] = []
    public var genreString = ""
    public var voteAverage = ""
            
    public var starImageArray = [UIImage]()
    
    public func loadMovieDetails(id: Int, _ completion: @escaping() -> ()) {
        guard let url = URL(string: Constants.detailUrl+String(id)+Constants.detailApiKey) else { return }
        let resource = Resource<MovieDetailModel>(url: url)
        
        Task {
            let detail = await service.fetchMovies(resource: resource)
            switch detail {
            case .success(let detail):
                self.details = detail
                self.generateGenres(genres: self.details?.genres)
                self.generateStars(voteAverage: self.details!.voteAverage)
                self.voteAverage = "\(String(format: "%.1f", self.details?.voteAverage as! CVarArg))/10"
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func generateGenres(genres: [Genre]?) {
        guard let genres = genres else { return }
        for genre in genres {
            self.genreNames.append(String(genre.name))
        }
        self.genreString = self.genreNames.joined(separator: ", ")
    }
    private func generateStars(voteAverage: Double) {
        switch voteAverage {
        case 10.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star)])
        case 8.1..<10.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.halfStar)])
        case 8.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.emptyStar)])
        case 6.1..<8.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.halfStar),
                                               getStars(StarImage.emptyStar)])
        case 6.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar)])
        case 4.1..<6.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.halfStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar)])
        case 4.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.star),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar)])
        case 2.1..<4.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.halfStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar)])
        case 2.0:
            starImageArray.append(contentsOf: [getStars(StarImage.star),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar)])
        case 0.0..<2.0:
            starImageArray.append(contentsOf: [getStars(StarImage.halfStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar)])
        default:
            starImageArray.append(contentsOf: [getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar),
                                               getStars(StarImage.emptyStar)])
        }
    }
    
    func getStars(_ image: StarImage) -> UIImage {
        switch image {
        case .star:
            return UIImage(named: StarImage.star.rawValue)!
        case .halfStar:
            return UIImage(named: StarImage.halfStar.rawValue)!
        case .emptyStar:
            return UIImage(named: StarImage.emptyStar.rawValue)!
        }
    }
}

enum StarImage: String {
    case star = "star"
    case halfStar = "halfStar"
    case emptyStar = "emptyStar"
}
