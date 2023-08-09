//
//  NetworkManager.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/09.
//

import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정의

enum NetworkError: Error {
  case networkingError
  case dataError
  case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델

final class NetworkManager {
  
  // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
  static let shared = NetworkManager()
  // 여러객체를 추가적으로 생성하지 못하도록 설정
  private init() {}
  
  typealias NetworkCompletion = (Result<[User], NetworkError>) -> Void
  
  // 네트워킹 요청하는 함수
  func fetchUser(searchTerm: String, completion: @escaping NetworkCompletion) {
    let urlString = "https://b05abb42-ed16-4e8f-a034-39ce4655c5e5.mock.pstmn.io/api/employee/1"
    getMethod(with: urlString) { result in
      completion(result)
    }
  }
  
  private func getMethod(with urlString: String, completion: @escaping (Result<[User], NetworkError>) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(.failure(.networkingError))
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completion(.failure(.networkingError))
        return
      }
      guard let safeData = data else {
        completion(.failure(.dataError))
        return
      }
      guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
        completion(.failure(.networkingError))
        return
      }
      do {
        let decoder = JSONDecoder()
        if let userDictionary = try JSONSerialization.jsonObject(with: safeData) as? [[String: Any]] {
          let userArray = userDictionary.compactMap { user in
            return try? decoder.decode(User.self, from: JSONSerialization.data(withJSONObject: user))
          }
          completion(.success(userArray))
        } else {
          let user = try decoder.decode(User.self, from: safeData)
          completion(.success([user]))
        }
      } catch {
        completion(.failure(.parseError))
      }
    }.resume()
  }
}
