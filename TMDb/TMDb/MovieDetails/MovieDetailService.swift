//
//  MovieDetailService.swift
//  TMDb
//
//  Created by Lucas Santos on 05/04/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import Foundation

class MovieDetailService {

    // MARK: - Properties
    private let moviePath = "movie/"

    // MARK: - Methods
    func getMovieDetail(movieId: Int,
                        callback: @escaping (Movie?) -> Void) {
        let requestPath = "\(moviePath)\(movieId)?"
        NetworkManager.get(requestPath,
                           type: Movie.self,
                           onComplete: { (movie) in
                            callback(movie)
            }, onError: { (error) in
                print(error ?? "")
                callback(nil)
        })
    }
}
