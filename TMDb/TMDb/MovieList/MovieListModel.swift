//
//  MovieListModel.swift
//  TMDb
//
//  Created by Lucas Santos on 30/03/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import Foundation

struct UpcomingMovie: Codable {
    let movieId: Int
    let title: String
    let posterPath: String?
    let releaseDate: String

    private enum CodingKeys: String, CodingKey {
        case movieId = "id", title, posterPath, releaseDate
    }
}

struct UpcomingMovieViewData {
    let movieId: Int
    let title: String
    let posterURL: URL?
    let releaseDate: String
}
