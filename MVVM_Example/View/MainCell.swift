//
//  MainCell.swift
//  MVVM_Example
//
//  Created by Sezgin on 31.03.2022.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    var movieName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var movieImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "dummyImage")
        iv.sizeToFit()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blur = UIVisualEffectView(effect: effect)
        blur.translatesAutoresizingMaskIntoConstraints = false
        return blur
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public func setMainCell(imageUrl: String?) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        contentView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 5).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(movieImage)
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        guard let imageUrl = imageUrl else { return }
        let url = URL(string: imageUrl)
        movieImage.downloaded(from: url!)
        
        contentView.addSubview(blurView)
        NSLayoutConstraint.activate([
          blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
          blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          blurView.heightAnchor.constraint(equalToConstant: 45),
          blurView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        contentView.addSubview(movieName)
        movieName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        movieName.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 5).isActive = true
        movieName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        movieName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        movieName.backgroundColor = .clear
        movieName.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        movieName.textColor = .secondarySystemBackground
        movieName.numberOfLines = 2
        movieName.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
