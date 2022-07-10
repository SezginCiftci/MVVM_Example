//
//  SavedMoviesViewController.swift
//  MVVM_Example
//
//  Created by Sezgin on 5.04.2022.
//

import UIKit

class SavedMoviesViewController: UIViewController {
    
    fileprivate var savedTableView: UITableView = {
        let table = UITableView()
        table.register(SavedCell.self, forCellReuseIdentifier: "savedCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var coreListModel: CoreDataListViewModel?
    var movieListVM = MovieListViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSavedVC()
        loadSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(loadSavedData), name: NSNotification.Name("newData"), object: nil)
        configureNavigtionBar()
    }
    
    private func configureNavigtionBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func loadSavedData() {
        CoreDataManager.shared.loadData { dataModel in
            self.coreListModel = dataModel
            self.savedTableView.reloadData()
        }
    }
    
    private func configureSavedVC() {
        view.backgroundColor = UIColor(red: 72/255, green: 69/255, blue: 139/255, alpha: 1)
        title = "Saved Movies"
        
        savedTableView.delegate = self
        savedTableView.dataSource = self
        
        view.addSubview(savedTableView)
        view.addSubview(savedTableView)
        NSLayoutConstraint.activate([
            savedTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            savedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        savedTableView.backgroundColor = .secondarySystemBackground
    }
}
//MARK: - TableView Delegate Methods 
extension SavedMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.savedTableView.frame.height/8)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coreListModel?.titleArray.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell", for: indexPath) as! SavedCell
        cell.accessoryType = .disclosureIndicator
        cell.configureCell(movieImage: self.coreListModel?.movieImageArray[indexPath.row] ?? UIImage(named: "dummyImage")!,
                           title: (self.coreListModel?.titleArray[indexPath.row]) ?? "No Title")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailViewController()
        detailVC.detailImageView.image = self.coreListModel?.movieImageArray[indexPath.row]
        detailVC.loadData(id: self.coreListModel?.movieIdArray[indexPath.row] ?? 0)
        detailVC.getFavoriteImage(self.coreListModel?.titleArray ?? [],
                                  self.coreListModel?.titleArray[indexPath.row] ?? "")
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let chosenId = self.coreListModel?.idArray[indexPath.row] else { return }
            CoreDataManager.shared.deleteData(with: chosenId) { dataModel in
                self.coreListModel?.titleArray.remove(at: indexPath.row)
                self.coreListModel?.idArray.remove(at: indexPath.row)
                self.coreListModel?.movieImageArray.remove(at: indexPath.row)
                self.coreListModel?.movieIdArray.remove(at: indexPath.row)
                self.savedTableView.reloadData()
                
                NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            }
        }
    }
}
