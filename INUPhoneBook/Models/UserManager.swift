//
//  UserManager.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/09.
//

import UIKit
import CoreData

//MARK: - 데이터 관리 모델 (전체 관리)

final class UserManager {
  
  // 저장된 데이터, 서버에서 받아오는 데이터 등, 여러화면의 모든 것을 관리하니 싱글톤으로 만듦
  static let shared = UserManager()
  
  // 초기화할때 저장된 데이터 셋팅
  private init() {
    fetchUsersFromCoreData {
      print("저장된 데이터셋팅완료")
    }
  }
  
  // 네트워크 매니저 (싱글톤)
  private let networkManager = NetworkManager.shared
  
  // 코어데이터 매니저 (싱글톤)
  private let coredataManager = CoreDataManager.shared
  
  // 서버에서 받아온 사용자 배열 (검색어에 따라 변경됨)
  private var userApiDatas: [User] = []
  
  // 코어데이터에 저장된 사용자 모델(entity) 배열
  private var userSavedDatas: [Users] = []
  
  func getUsersFromAPI() -> [User] {
    return userApiDatas
  }
  
  func getUsersFromCoreData() -> [Users] {
    return userSavedDatas
  }
  
  //MARK: - API 통신 관련 메서드
  
  // (특정 단어로) 검색하기
  func fetchUsersFromAPI(with searchTerm: String, completion: @escaping () -> Void) {
    getUsersFromAPI(with: searchTerm) {
      completion()
    }
  }
  
  // 네트워크 매니저한테 요청해서 (서버에서) 데이터 가져오기
  private func getUsersFromAPI(with searchTerm: String, completion: @escaping () -> Void) {
    networkManager.fetchUser(searchTerm: searchTerm) { result in
      switch result {
      case .success(let userDatas):
        dump(userDatas)
        self.userApiDatas = [userDatas.data]
        self.checkWhetherSaved()
        completion()
      case .failure(let error):
        print(error.localizedDescription)
        self.checkWhetherSaved()
        completion()
      }
    }
  }
  
  //MARK: - 코어데이터와 커뮤니케이션하는 메서드
  // 처음 셋팅하는 메서드
  private func setupUsersFromCoreData(completion: () -> Void) {
    fetchUsersFromCoreData {
      completion()
    }
  }
  
  // Create (데이터 생성하기)
  func saveUserData(with user: User, completion: @escaping () -> Void) {
    coredataManager.saveUser(with: user) {
      self.fetchUsersFromCoreData {
        completion()
      }
    }
  }
  
  func deleteUser(with user: User, completion: @escaping () -> Void) {
    // 동일한 데이터(제목&가수이름)를 가진 것들을 찾아내서 (배열로 리턴)
    let usersSaved = userSavedDatas.filter { $0.id == user.id }
    
    // 전달
    if let targetUserSaved = usersSaved.first {
      self.deleteUserFromCoreData(with: targetUserSaved) {
        print("지우기 완료")
        completion()
      }
    } else {
      print("저장된 것 없음")
      completion()
    }
  }
  
  // Delete (데이터 지우기) - Users(entity)를 가진 데이터 지우기
  func deleteUserFromCoreData(with user: Users, completion: @escaping () -> Void) {
    guard let context = CoreDataManager.shared.context else {
      completion()
      return
    }
    
    context.delete(user)
    coredataManager.deleteUser(with: user) {
      self.fetchUsersFromCoreData {}
    }
    do {
      try context.save()
      completion()
    } catch {
      print(error)
      completion()
    }
  }
  
  
  // Read (모든 Users(entity) 불러오기) (코어데이터에서 가져와서)
  private func fetchUsersFromCoreData(completion: () -> Void) {
    userSavedDatas = coredataManager.getUserArrayFromCoreData()
    completion()
  }
  
  // 이미 저장된 데이터인지 확인하기 (다른 화면에서 저장 여부 표시하기 위해)
  func checkWhetherSaved() {
    userApiDatas.forEach { user in
      //코어데이터에 저장된 것들 중 음악 및 가수 이름이 같은 것 찾아내서
      if userSavedDatas.contains(where: {
        $0.id == user.id && $0.name == user.name
      }) {
        user.isSaved = true
        
      }
    }
  }
}

