//
//  MovieListPresenter.swift
//  TMDb
//
//  Created by Lucas Santos on 30/03/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import Foundation

protocol MovieListView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setMovieList(_ list: [UpcomingMovieViewData])
    func finishPagination()
}

class MovieListPresenter {

    // MARK: - Properties
    private let posterBaseURL = "https://image.tmdb.org/t/p/w185/"
    private let movieListService: MovieListService
    weak private var movieListView: MovieListView?

    // MARK: - Methods
    init(_ service: MovieListService) {
        movieListService = service
    }

    func attachView(_ view: MovieListView) {
        movieListView = view
    }

    func dettachView() {
        movieListView = nil
    }

    func getMovieList() {
        self.movieListService.getMovieList { [weak self] (upcomingMovieArray, lastPage) in
            self?.movieListView?.finishLoading()
            if let upcomingMovieArray = upcomingMovieArray,
                let view = self?.movieListView,
                let viewData = self?.mapDataToViewData(upcomingMovieArray) {
                DispatchQueue.main.async {
                    view.setMovieList(viewData)
                }
            }
            if lastPage {
                self?.movieListView?.finishPagination()
            }
        }
    }

    func mapDataToViewData(_ movieArray: [UpcomingMovie]) -> [UpcomingMovieViewData] {
        return movieArray.map {
            let posterURL = URL(string: "\(self.posterBaseURL)\($0.posterPath ?? "")")
            return UpcomingMovieViewData(movieId: $0.movieId,
                                         title: $0.title,
                                         posterURL: posterURL,
                                         releaseDate: $0.releaseDate)
        }
    }
}
