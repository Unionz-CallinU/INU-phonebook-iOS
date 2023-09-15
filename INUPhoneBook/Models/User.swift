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
  let data: EmployeeData
}

struct EmployeeData: Codable {
  let employeeDtoList: [User]
}

struct User: Codable {
  var id: Int
  var name: String?
  var college: String?
  var phoneNumber: String? = "-"
  var department: String?
  var role: String? = "-"
  var email: String? = "-"
  var imageUrl: String? = "없음"
  var isSaved: Bool?
  var category: String? = "기본"
}
