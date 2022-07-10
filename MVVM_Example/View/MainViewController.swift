//
//  ViewController.swift
//  MVVM_Example
//
//  Created by Sezgin on 31.03.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    var movieCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        var movieCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        movieCV.translatesAutoresizingMaskIntoConstraints = false
        movieCV.register(MainCell.self, forCellWithReuseIdentifier: "movieCell")
        return movieCV
    }()
    fileprivate var movieListVM = MovieListViewModel()
    fileprivate var coreDataListModel: CoreDataListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCV()
        loadData()
        loadCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadCoreData),
                                               name: NSNotification.Name("newData"),
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("newData"),
                                                  object: nil)
    }
    
    @objc private func loadCoreData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            CoreDataManager.shared.loadData { dataModel in
                self.coreDataListModel = dataModel
            }
        }
    }
    
    private func loadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movieListVM.loadMovieList {
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    private func configureCV() {
        view.backgroundColor = UIColor(red: 72/255, green: 69/255, blue: 139/255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Popular Movies"
        
        let folderButton = UIBarButtonItem(barButtonSystemItem: .organize,
                                                            target: self,
                                                            action: #selector(handleFavoriteFolderButton))
        folderButton.tintColor = .black
        navigationItem.rightBarButtonItem = folderButton
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        view.addSubview(movieCollectionView)
        NSLayoutConstraint.activate([
            movieCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        movieCollectionView.backgroundColor = .clear
    }
    @objc func handleFavoriteFolderButton() {
        let savedVC = SavedMoviesViewController()
        self.navigationController?.pushViewController(savedVC, animated: true)
    }
    @objc func handleSearchButton() {
        print("search tapped")
    }
}
//MARK: - CollectionView Delegate Methods
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 5, height: collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieListVM.movies?.results.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MainCell
        
        cell.setMainCell(imageUrl: Constants.imgBaseUrl+(self.movieListVM.movies?.results[indexPath.row].posterPath)!)
        cell.movieName.text = self.movieListVM.movies?.results[indexPath.row].title
        self.movieListVM.movieTitles.append((self.movieListVM.movies?.results[indexPath.row].title)!)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let detailVC = DetailViewController()
        detailVC.detailTitle = self.movieListVM.movies?.results[indexPath.row].title ?? "No movie"
        detailVC.loadImage(backImageUrl: Constants.imgBaseUrl+(self.movieListVM.movies?.results[indexPath.row].posterPath)!)
        detailVC.loadData(id: self.movieListVM.movies?.results[indexPath.row].id ?? 0)
        
        let coreTitleArray = self.coreDataListModel?.titleArray ?? []
        detailVC.getFavoriteImage(coreTitleArray, detailVC.detailTitle)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}







