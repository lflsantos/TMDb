//
//  MovieListCollectionViewController.swift
//  TMDb
//
//  Created by Lucas Santos on 30/03/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    private let reuseIdentifier = "upcomingMovieCell"
    private let presenter = MovieListPresenter(MovieListService())
    private var moviesData: [UpcomingMovieViewData] = []
    private let posterCache = NSCache<NSString, UIImage>()
    private var fullyLoaded = false

    // MARK: - Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startLoading()

        collectionView.delegate = self
        collectionView.dataSource = self

        presenter.attachView(self)
        presenter.getMovieList()
    }

    // MARK: - Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? MovieDetailViewController,
            let cell = sender as? UpcomingMovieCollectionViewCell,
            let index = collectionView.indexPath(for: cell) {
            detailVC.movieId = moviesData[index.row].movieId
        }
    }
}

extension MovieListViewController: MovieListView {
    // MARK: MovieListView implementation
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

    func setMovieList(_ list: [UpcomingMovieViewData]) {
        self.moviesData += list
        self.collectionView.reloadData()
    }

    func finishPagination() {
        self.fullyLoaded = true
    }
}

extension MovieListViewController: UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesData.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? UpcomingMovieCollectionViewCell  else {
            return UICollectionViewCell()
        }

        let movieData = moviesData[indexPath.row]
        updateCell(cell, movieData: movieData)
        return cell
    }

    // MARK: Support Methods
    func updateCell(_ cell: UpcomingMovieCollectionViewCell,
                    movieData: UpcomingMovieViewData) {
        cell.lblName.text = movieData.title
        cell.ivPoster.image = nil

        if let cachedPoster = posterCache.object(forKey: NSString(string: movieData.title)) {
            cell.ivPoster.image = cachedPoster
        } else if let posterURL = movieData.posterURL {
            cell.ivPoster.downloadImage(url: posterURL) { [weak self] (image) in
                if let image = image {
                    self?.posterCache.setObject(image, forKey: movieData.title as NSString)
                }
            }
        }
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row + 3 == moviesData.count && !fullyLoaded {
            self.presenter.getMovieList()
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 300)
    }
}
