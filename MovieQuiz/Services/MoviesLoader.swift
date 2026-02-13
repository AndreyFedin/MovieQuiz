//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by PowerMiG29 on 08.02.2026.
//

import Foundation

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var decoder = JSONDecoder()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    private enum NetworkError: LocalizedError {
        case serverError(String)
        
        var errorDescription: String? {
            switch self {
            case .serverError(let error):
                return error
            }
        }
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try decoder.decode(MostPopularMovies.self, from: data)
                    if !mostPopularMovies.errorMessage.isEmpty && mostPopularMovies.items.isEmpty {
                        let error = NetworkError.serverError(mostPopularMovies.errorMessage)
                        handler(.failure(error))
                    }
                    else {
                        handler(.success(mostPopularMovies))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
