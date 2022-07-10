//
//  MovieListModel.swift
//  MVVM_Example
//
//  Created by Sezgin on 31.03.2022.
//

import Foundation


// MARK: - MovieListModel
struct MovieListModel: Codable {
    let page: Int
    let results: [ResultData]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
 struct ResultData: Codable {
    let overview, releaseDate: String
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let voteCount: Int
    let originalTitle, posterPath, title: String
    let video: Bool
    let voteAverage: Double
    let id: Int
    let popularity: Double
    let mediaType: MediaType

    enum CodingKeys: String, CodingKey {
        case overview
        case releaseDate = "release_date"
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case voteCount = "vote_count"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case title, video
        case voteAverage = "vote_average"
        case id, popularity
        case mediaType = "media_type"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
}
