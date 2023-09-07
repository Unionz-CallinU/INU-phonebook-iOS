//
//  Users+CoreDataProperties.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/09/07.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var category: String?
    @NSManaged public var college: String?
    @NSManaged public var department: String?
    @NSManaged public var email: String?
    @NSManaged public var id: Int16
    @NSManaged public var isSaved: Bool
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var role: String?

}

extension Users : Identifiable {

}
