//
//  Users+CoreDataProperties.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/09.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var college: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var department: String?
    @NSManaged public var role: String?
    @NSManaged public var email: String?

}

extension Users : Identifiable {

}
