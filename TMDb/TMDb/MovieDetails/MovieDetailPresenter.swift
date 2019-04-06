//
//  MovieDetailPresenter.swift
//  TMDb
//
//  Created by Lucas Santos on 05/04/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import Foundation

protocol MovieDetailView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setMovie(_ movie: MovieViewData)
}

class MovieDetailPresenter {

    // MARK: - Properties
    private let imageBaseURL = "https://image.tmdb.org/t/p/original/"
    private let movieDetailService: MovieDetailService
    weak private var movieDetailView: MovieDetailView?

    // MARK: - Methods
    init(_ service: MovieDetailService) {
        movieDetailService = service
    }

    func attachView(_ view: MovieDetailView) {
        movieDetailView = view
    }

    func dettachView() {
        movieDetailView = nil
    }

    func getMovieList(movieId: Int) {
        self.movieDetailView?.startLoading()
        self.movieDetailService.getMovieDetail(movieId: movieId) { [weak self] (movie) in
            self?.movieDetailView?.finishLoading()
            if let movie = movie,
                let view = self?.movieDetailView,
                let viewData = self?.mapDataToViewData(movie) {
                DispatchQueue.main.async {
                    view.setMovie(viewData)
                }
            }
        }
    }

    func mapDataToViewData(_ movie: Movie) -> MovieViewData {
        let backdropURL = URL(string: "\(self.imageBaseURL)\(movie.backdropPath ?? "")")

        let posterURL = URL(string: "\(self.imageBaseURL)\(movie.posterPath ?? "")")

        let genres = movie.genres.reduce("") { (appendedGenres, nextGenre) -> String in
            return (appendedGenres == "") ? nextGenre.name : "\(appendedGenres) | \(nextGenre.name)"
        }

        let dateFormatter = DateFormatter()
        var formattedDate = movie.releaseDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: movie.releaseDate) {
            dateFormatter.dateFormat = "EEEE, MMMM d yyyy"
            formattedDate = dateFormatter.string(from: date)
        }

        return MovieViewData(title: movie.originalTitle,
                             genres: genres,
                             releaseDate: formattedDate,
                             overview: movie.overview,
                             backdropURL: backdropURL,
                             posterURL: posterURL)
    }

    func downloadBackdropData(_ backdropURL: URL,
                              callback: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: backdropURL)
                DispatchQueue.main.async {
                    callback(data)
                }
            } catch {
                print("Error downloading backdrop image: \(backdropURL.absoluteString)")
            }
        }
    }

}
