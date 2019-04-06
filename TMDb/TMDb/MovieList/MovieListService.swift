//
//  MovieListService.swift
//  TMDb
//
//  Created by Lucas Santos on 31/03/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import Foundation

class MovieListService {

    // MARK: - Properties
    private let movieListPath = "movie/upcoming"
    private var currentPage: Int = 1
    private var totalPages: Int?

    // MARK: - Methods
    func getMovieList(callback: @escaping ([UpcomingMovie]?, Bool) -> Void) {
        let requestPath = "\(movieListPath)?page=\(currentPage)&"
        NetworkManager.getWithPagination(requestPath,
                           type: UpcomingMovie.self,
                           onComplete: { [weak self] (movieList, currentPage, totalPages) in
                            self?.currentPage = currentPage + 1
                            self?.totalPages = totalPages
                            callback(movieList, currentPage == totalPages)
        }, onError: { (error) in
            print(error ?? "")
            callback(nil, false)
        })
    }
}
