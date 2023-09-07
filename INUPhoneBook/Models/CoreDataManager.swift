//
//  CoreDataManager.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/09.
//

import UIKit
import CoreData

final class CoreDataManager {
  
  // 싱글톤으로 만들기
  static let shared = CoreDataManager()
  private init() {}
  
  // 앱 델리게이트
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  
  // 임시저장소
  lazy var context = appDelegate?.persistentContainer.viewContext
  
  // 엔터티 이름 (코어데이터에 저장된 객체)
  let modelName: String = "Users"
  
  // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
  func getUserArrayFromCoreData() -> [Users] {
    var savedUserList: [Users] = []
    if let context = context {
      let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
      let savedDate = NSSortDescriptor(key: "id", ascending: true)
      request.sortDescriptors = [savedDate]
      do {
        if let fetchedUserList = try context.fetch(request) as? [Users] {
          savedUserList = fetchedUserList
        }
      } catch {
        print("가져오는 것 실패")
      }
    }
    return savedUserList
  }
  
  // MARK: - [Create] 코어데이터에 데이터 생성하기 (Music ===> MusicSaved)
  func saveUser(with user: User, completion: @escaping () -> Void) {
    if let context = context, let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
      let userSaved = Users(entity: entity, insertInto: context)
      
      userSaved.phoneNumber = user.phoneNumber
      userSaved.name = user.name
      userSaved.college = user.college
      userSaved.email = user.email
      userSaved.department = user.department
      userSaved.role = user.role
      userSaved.id = Int16(user.id)
      userSaved.category = user.category
      userSaved.isSaved = user.isSaved!
      
      do {
        try context.save()
        completion()
      } catch {
        print(error)
      }
    }
  }
  
  func updateCategory(for user: Users, with category: String, completion: @escaping () -> Void) {
      user.category = category
      
      do {
          try context?.save()
          completion()
      } catch {
          print(error)
      }
  }

  // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
  func deleteUser(with user: Users, completion: @escaping () -> Void) {
    guard let savedID = user.id, let context = context else {
      completion()
      return
    }
    let request = NSFetchRequest<Users>(entityName: modelName)
    request.predicate = NSPredicate(format: "id = %@", savedID)
    do {
      let fetchedUserList = try context.fetch(request)
      if let targetUser = fetchedUserList.first {
        context.delete(targetUser)
        if context.hasChanges {
          do {
            try context.save()
            completion()
          } catch {
            print(error)
            completion()
          }
        } else {
          completion()
        }
      } else {
        completion()
      }
    } catch {
      print(error)
      completion()
    }
  }
  
}
