//
//  Categories+CoreDataProperties.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/09/11.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var cellCategory: String?

}

extension Categories : Identifiable {

}
