//
//  CoreDataManager.swift
//  MVVM_Example
//
//  Created by Sezgin on 4.04.2022.
//

import UIKit
import CoreData

class CoreDataManager {
    static var shared = CoreDataManager()
    
    func saveData(title: String, movieImage: UIImage?, id: UUID, movieId: Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let selectedMovie = NSEntityDescription.insertNewObject(forEntityName: "MovieEntity", into: context)
        
        selectedMovie.setValue(title, forKey: "title")
        selectedMovie.setValue(movieId, forKey: "movieId")
        selectedMovie.setValue(id, forKey: "id")
        
        guard let imageData = movieImage?.jpegData(compressionQuality: 0.5) else { return }
        selectedMovie.setValue(imageData, forKey: "movieImage")

        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
    }
    func loadData(completion: ((_ dataModel: CoreDataListViewModel) -> ())) {
        var dataModel = CoreDataListViewModel()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                dataModel.titleArray.removeAll(keepingCapacity: false)
                dataModel.idArray.removeAll(keepingCapacity: false)
                dataModel.movieImageArray.removeAll(keepingCapacity: false)
                dataModel.movieIdArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        dataModel.titleArray.append(title)
                    }
                    if let movieId = result.value(forKey: "movieId") as? Int {
                        dataModel.movieIdArray.append(movieId)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        dataModel.idArray.append(id)
                    }
                    if let imageData = result.value(forKey: "movieImage") as? Data {
                        if let image = UIImage(data: imageData) {
                            dataModel.movieImageArray.append(image)
                        } else  {
                            dataModel.movieImageArray.append(UIImage(named: "dummyImage")!)
                        }
                    }
                }
            }
            completion(dataModel)
        } catch {
            completion(dataModel)
        }
    }
    func deleteData(with chosenId: UUID, comletion: ((_ dataModel: CoreDataViewModel) -> ())) {
        var dataModel = CoreDataViewModel()
        dataModel.id = chosenId
        
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let idString = chosenId.uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count >= 0 {
                
                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID {
                        if id == chosenId {
                            context.delete(result)
                            comletion(dataModel)
                            do {
                                try context.save()
                            } catch {
                                print("error")
                            }
                            break
                        }
                    }
                }
            }
        } catch {
            
        }
    }
}
