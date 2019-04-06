//
//  MovieModel.swift
//  TMDb
//
//  Created by Lucas Santos on 30/03/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let backdropPath: String?
    let genres: [Genre]
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
}

struct Genre: Decodable {
    let name: String
}

struct MovieViewData {
    let title: String
    let genres: String
    let releaseDate: String
    let overview: String
    let backdropURL: URL?
    let posterURL: URL?
}
