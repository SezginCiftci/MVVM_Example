//
//  DetailViewController.swift
//  MVVM_Example
//
//  Created by Sezgin on 1.04.2022.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: - Detail UI Properties
    public var detailImageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.sizeToFit()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private var detailViewForImage : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var runtimeLabel: UILabel = {
        let label = MakeProperty.makeLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private var genresLabel: UILabel = {
        let label = MakeProperty.makeLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private var typeLabel: UILabel = {
        let label = MakeProperty.makeLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private var runtimeImageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .secondarySystemBackground
        iv.image = UIImage(named: "stopwatch")
        return iv
    }()
    
    private var firstStarImageView : UIImageView = {
        let iv = MakeProperty.makeStarImageView()
        return iv
    }()
    private var secondStarImageView : UIImageView = {
        let iv = MakeProperty.makeStarImageView()
        return iv
    }()
    private var thirdStarImageView : UIImageView = {
        let iv = MakeProperty.makeStarImageView()
        return iv
    }()
    private var forthStarImageView : UIImageView = {
        let iv = MakeProperty.makeStarImageView()
        return iv
    }()
    private var fifthStarImageView : UIImageView = {
        let iv = MakeProperty.makeStarImageView()
        return iv
    }()
    
    private var ratingLabel: UILabel = {
        let label = MakeProperty.makeLabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var overviewLabel: UILabel = {
        let label = MakeProperty.makeLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 7
        return label
    }()
    private var websiteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 20
        button.setTitle("Go to the Homepage", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.sizeToFit()
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleWebsiteButton), for: .touchUpInside)
        return button
    }()
   
    private var coreListVM: CoreDataListViewModel?
    private var detailVM = MovieDetailViewModel()
    
    private var movieTitle = ""
    private var movieId = 0
    public var detailTitle = ""
    
    private var websiteUrl: String? {
        didSet {
            if websiteUrl != nil && websiteUrl != "" {
                websiteButton.alpha = 1
            } else {
                websiteButton.alpha = 0.3
            }
        }
    }
    private var favoriteButtonImage = UIImage()
    
    //MARK: - Detail Assignments and UI Logic
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    func loadData(id: Int) {
        DispatchQueue.main.async {
            self.detailVM.loadMovieDetails(id: id) {
                self.runtimeLabel.text = "\(String(self.detailVM.details?.runtime ?? 0)) min."
                self.genresLabel.text = self.detailVM.genreString
                self .generateStarImages(self.detailVM.starImageArray)
                self.ratingLabel.text = self.detailVM.voteAverage
                self.overviewLabel.text = self.detailVM.details?.overview
                self.websiteUrl = self.detailVM.details?.homepage
                self.movieTitle = self.detailVM.details?.title ?? "No Title"
                self.movieId = self.detailVM.details?.id ?? 0
            }
        }
    }
    private func generateStarImages(_ starImages: [UIImage]) {
        self.firstStarImageView.image = starImages[0]
        self.secondStarImageView.image = starImages[1]
        self.thirdStarImageView.image = starImages[2]
        self.forthStarImageView.image = starImages[3]
        self.fifthStarImageView.image = starImages[4]
    }
    public func loadImage(backImageUrl: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let imageUrl = backImageUrl else { return }
            let url = URL(string: imageUrl)
            self?.detailImageView.downloaded(from: url!)
        }
    }
    @objc private func handleFavButton() {
        let starFill = UIImage(systemName: "star.fill")
        
        if navigationItem.rightBarButtonItem?.image == starFill {
            present(MakeAlert.makeAlertView("Error!",
                                            "Favorite movies can only be deleted from the favorite folder by swiping!"),
                    animated: true, completion: nil)
        } else {
            navigationItem.rightBarButtonItem?.image = starFill!
            CoreDataManager.shared.saveData(title: movieTitle,
                                            movieImage: detailImageView.image,
                                            id: UUID(),
                                            movieId: movieId)
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        }
    }
    func getFavoriteImage(_ titleArray: [String], _ selectedTitle: String) {
        if titleArray.contains(selectedTitle) {
            favoriteButtonImage = UIImage(systemName: "star.fill")!
        } else {
            favoriteButtonImage = UIImage(systemName: "star")!
        }
    }    
    @objc private func handleWebsiteButton() {
        if websiteUrl != nil && websiteUrl != "" {
            guard let url = URL(string: websiteUrl!) else { return }
            UIApplication.shared.open(url, completionHandler: nil)
        } else {
            present(MakeAlert.makeAlertView("Error!", "Url does not exist!"), animated: true)
        }
    }
    //MARK: - Constraints
    func configureDetailUI() {
        view.backgroundColor =  UIColor(red: 72/255, green: 69/255, blue: 139/255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: favoriteButtonImage,
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(handleFavButton))
        
        view.addSubview(detailImageView)
        NSLayoutConstraint.activate([
            detailImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            detailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailImageView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        view.addSubview(detailViewForImage)
        NSLayoutConstraint.activate([
            detailViewForImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            detailViewForImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailViewForImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailViewForImage.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        view.addSubview(genresLabel)
        NSLayoutConstraint.activate([
            genresLabel.centerXAnchor.constraint(equalTo: detailViewForImage.centerXAnchor),
            genresLabel.bottomAnchor.constraint(equalTo: detailViewForImage.bottomAnchor, constant: -10)
        ])
        genresLabel.numberOfLines = 2
        
        detailViewForImage.addSubview(runtimeLabel)
        NSLayoutConstraint.activate([
            runtimeLabel.trailingAnchor.constraint(equalTo: genresLabel.leadingAnchor, constant: -15),
            runtimeLabel.bottomAnchor.constraint(equalTo: detailViewForImage.bottomAnchor, constant: -10)
        ])
        detailViewForImage.addSubview(runtimeImageView)
        NSLayoutConstraint.activate([
            runtimeImageView.bottomAnchor.constraint(equalTo: detailViewForImage.bottomAnchor, constant: -10),
            runtimeImageView.trailingAnchor.constraint(equalTo: runtimeLabel.leadingAnchor, constant: -5),
            runtimeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            runtimeImageView.heightAnchor.constraint(equalToConstant: 22),
            runtimeImageView.widthAnchor.constraint(equalToConstant: 22)
        ])
        
        detailViewForImage.addSubview(typeLabel)
        NSLayoutConstraint.activate([
            typeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            typeLabel.bottomAnchor.constraint(equalTo: detailViewForImage.bottomAnchor, constant: -10)
        ])
        typeLabel.text = "Movie"
        
        view.addSubview(thirdStarImageView)
        thirdStarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        starImageViewConstraints(thirdStarImageView)
        
        view.addSubview(secondStarImageView)
        secondStarImageView.trailingAnchor.constraint(equalTo: thirdStarImageView.leadingAnchor, constant: -10).isActive = true
        starImageViewConstraints(secondStarImageView)
        
        view.addSubview(firstStarImageView)
        firstStarImageView.trailingAnchor.constraint(equalTo: secondStarImageView.leadingAnchor, constant: -10).isActive = true
        starImageViewConstraints(firstStarImageView)
        
        view.addSubview(forthStarImageView)
        forthStarImageView.leadingAnchor.constraint(equalTo: thirdStarImageView.trailingAnchor, constant: 10).isActive = true
        starImageViewConstraints(forthStarImageView)
        
        view.addSubview(fifthStarImageView)
        fifthStarImageView.leadingAnchor.constraint(equalTo: forthStarImageView.trailingAnchor, constant: 10).isActive = true
        starImageViewConstraints(fifthStarImageView)
        
        view.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: thirdStarImageView.bottomAnchor, constant: 15),
            ratingLabel.heightAnchor.constraint(equalToConstant: 30),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.addSubview(websiteButton)
        NSLayoutConstraint.activate([
            websiteButton.heightAnchor.constraint(equalToConstant: 40),
            websiteButton.widthAnchor.constraint(equalToConstant: 200),
            websiteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            websiteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        view.addSubview(overviewLabel)
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            overviewLabel.bottomAnchor.constraint(equalTo: websiteButton.topAnchor, constant: -20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    func starImageViewConstraints(_ starImageView: UIImageView) {
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: detailViewForImage.bottomAnchor, constant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 30),
            starImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
