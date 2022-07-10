//
//  CoreDataViewModel.swift
//  MVVM_Example
//
//  Created by Sezgin on 4.04.2022.
//

import UIKit

struct CoreDataListViewModel {
    var titleArray = [String]()
    var movieImageArray = [UIImage]()
    var movieIdArray = [Int]()
    var idArray = [UUID]()
}

struct CoreDataViewModel {
    var title: String?
    var movieImage: UIImage?
    var movieId: Int?
    var id: UUID?
}

