//
//  UpcomingMovieCollectionViewCell.swift
//  TMDb
//
//  Created by Lucas Santos on 04/04/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import UIKit

class UpcomingMovieCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    // MARK: - Methods
    func updateCell(_ movie: UpcomingMovieViewData) {
        self.lblName.text = movie.title
    }
}
