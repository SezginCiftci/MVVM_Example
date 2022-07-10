//
//  Webservice.swift
//  MVVM_Example
//
//  Created by Sezgin on 31.03.2022.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
}
struct Resource<T: Codable> {
    let url: URL
}
class Webservice {
    func fetchMovies<T>(resource: Resource<T>) async -> Result<T, Error> {
        do {
            let (data, response) = try await URLSession.shared.data(from: resource.url)
            let movies = try JSONDecoder().decode(T.self, from: data)
            guard let response = response as? HTTPURLResponse else { return .failure(NetworkError.domainError) }
            guard response.statusCode == 200 else { return .failure(NetworkError.domainError)}
            return .success(movies)
        } catch {
            return .failure(NetworkError.decodingError)
        }
    }
}
