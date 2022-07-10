//
//  SavedCell.swift
//  MVVM_Example
//
//  Created by Sezgin on 5.04.2022.
//

import UIKit

class SavedCell: UITableViewCell {
    
    private var savedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "dummyImage")
        iv.sizeToFit()
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    private var movieTitle: UILabel = {
        let label = MakeProperty.makeLabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 2
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    public func configureCell(movieImage: UIImage, title: String) {
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(savedImageView)
        NSLayoutConstraint.activate([
            savedImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            savedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            savedImageView.widthAnchor.constraint(equalToConstant: 70),
            savedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        savedImageView.image = movieImage

        contentView.addSubview(movieTitle)
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            movieTitle.leadingAnchor.constraint(equalTo: savedImageView.trailingAnchor, constant: 15),
            movieTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
        movieTitle.text = title
    }
}
