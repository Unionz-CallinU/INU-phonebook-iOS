//
//  User.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/09.
//

import UIKit

//MARK: - 데이터 모델

// 실제 API에서 받게 되는 정보

struct UserData: Codable {
  let code: Int
  let msg: String
  let data: User
}

class User: Codable {
  var id: String?
  var name: String?
  var college: String?
  var phoneNumber: String?
  var department: String?
  var role: String?
  var email: String?
  var isSaved: Bool = false
  var category: String = "기본"
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case college
    case phoneNumber
    case department
    case role
    case email
  }
}
