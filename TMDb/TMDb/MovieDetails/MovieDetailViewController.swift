//
//  MovieDetailViewController.swift
//  TMDb
//
//  Created by Lucas Santos on 05/04/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ivBackdrop: UIImageView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!

    // MARK: - Properties
    private let presenter = MovieDetailPresenter(MovieDetailService())
    private var movieData: MovieViewData?
    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(self)
        if let movieId = movieId {
            presenter.getMovieList(movieId: movieId)
        }
    }
}

extension MovieDetailViewController: MovieDetailView {
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }

    func finishLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    func setMovie(_ movie: MovieViewData) {
        movieData = movie
        lblTitle.text = movie.title
        lblGenres.text = movie.genres
        lblReleaseDate.text = movie.releaseDate
        lblOverview.text = movie.overview
        if let backdropURL = movie.backdropURL {
            ivBackdrop.downloadImage(url: backdropURL)
        }
        if let posterURL = movie.posterURL {
            ivPoster.downloadImage(url: posterURL)
        }
    }
}
