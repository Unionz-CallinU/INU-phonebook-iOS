//
//  CategoryManager.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/23.
//

import UIKit
import CoreData

class CategoryManager {
  static let shared = CategoryManager()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "INUPhoneBook")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        print("Failed to load Core Data stack:\n\(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  func save(sectionName: String) {
    guard let entityDescription = NSEntityDescription.entity(forEntityName: "Categories",
                                                             in: self.persistentContainer.viewContext) else {
      fatalError("Unable to find Entity name!")
    }
    
    let newSection = NSManagedObject(entity: entityDescription,
                                     insertInto: self.persistentContainer.viewContext)
    newSection.setValue(sectionName, forKey: "cellCategory")
    
    do {
      try self.persistentContainer.viewContext.save()
    } catch {
      print("Error saving context:\n\(error)")
    }
  }
  
  func deleteCategory(category: String) {
      let context = persistentContainer.viewContext
      
      // Fetch the categories to be deleted
      let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "cellCategory == %@", category)
      
      do {
          let categories = try context.fetch(fetchRequest)
          
          for category in categories {
              context.delete(category)
          }
          
          try context.save()
      } catch {
          print("Error deleting category:", error.localizedDescription)
      }
  }

  func fetchCategories() -> [Categories] {
    let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
    
    do {
      let categories = try persistentContainer.viewContext.fetch(fetchRequest)
      
      if categories.isEmpty {
        let defaultCategory = Categories(context: persistentContainer.viewContext)
        defaultCategory.cellCategory = "기본"
        
        try persistentContainer.viewContext.save()
        
        return [defaultCategory]
      }
      
      return categories
    } catch {
      print("Error fetching categories: \(error.localizedDescription)")
      return []
    }
  }

  
}
