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
      userSaved.id = user.id
      userSaved.category = user.category
      do {
        try context.save()
        completion()
      } catch {
        print(error)
      }
    }
  }
  
  
  // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
  func updateUser(with user: Users, completion: @escaping () -> Void) {
    // 날짜 옵셔널 바인딩
    guard let savedDate = user.id else {
      completion()
      return
    }
    
    // 임시저장소 있는지 확인
    if let context = context {
      // 요청서
      let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
      // 단서 / 찾기 위한 조건 설정
      request.predicate = NSPredicate(format: "savedDate = %@", savedDate as CVarArg)
      
      do {
        // 요청서를 통해서 데이터 가져오기
        if let fetchedMusicList = try context.fetch(request) as? [Users] {
          // 배열의 첫번째
          if var targetUser = fetchedMusicList.first {
            
            // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
            targetUser = user
            
            //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
            if context.hasChanges {
              do {
                try context.save()
                completion()
              } catch {
                print(error)
                completion()
              }
            }
          }
        }
        completion()
      } catch {
        print("지우는 것 실패")
        completion()
      }
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
