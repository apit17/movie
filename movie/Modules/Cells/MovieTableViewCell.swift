//
//  MovieTableViewCell.swift
//  movie
//
//  Created by Apit Gilang Aprida on 3/8/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(viewModel: MovieViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        yearLabel.text = viewModel.releaseDate
        directorLabel.text = viewModel.director
    }
    
}
