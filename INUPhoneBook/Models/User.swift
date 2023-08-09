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
  let resultCount: Int
  let results: [User]
}

// (저장여부 등을 지속적으로 관리(속성 변경 여부)해줘야해서, 클래스로 만듦)
struct User: Codable {
  let id: String?
  let name: String?
  let college: String?
  let phoneNumber: String?
  let department: String?
  let role: String?
  let email: String?
  var isSaved: Bool = false
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case college
    case phoneNumber = "phone_number"
    case department
    case role
    case email
  }
}
