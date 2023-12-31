import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정의
enum NetworkError: Error {
  case networkingError
  case dataError
  case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델
final class NetworkManager {
  
  static let shared = NetworkManager()
  private init() {}
  
  typealias NetworkCompletion = (Result<UserData, NetworkError>) -> Void
  
  // 네트워킹 요청하는 함수
  func fetchUser(searchTerm: String, completion: @escaping NetworkCompletion) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "callinu.inuappcenter.kr"
    urlComponents.path = "/api/v1/employee"
    
    let searchQueryItem = URLQueryItem(name: "employeeSearchReqDto", value: searchTerm)
    urlComponents.queryItems = [searchQueryItem]
    
    guard let urlString = urlComponents.url?.absoluteString else {
      print("Invalid URL")
      completion(.failure(.networkingError))
      return
    }
    
    getMethod(with: urlString, completion: completion)
  }
  
  private func getMethod(with urlString: String, completion: @escaping NetworkCompletion) {
    guard let url = URL(string: urlString) else {
      print("Invalid URL")
      completion(.failure(.networkingError))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Networking Error:", error)
        completion(.failure(.networkingError))
        return
      }
      
      guard let safeData = data else {
        print("No Data")
        completion(.failure(.dataError))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        print("Invalid Response")
        completion(.failure(.networkingError))
        return
      }
      
      print("Response Status Code:", httpResponse.statusCode)
      
      do {
        let decoder = JSONDecoder()
        let userData = try decoder.decode(UserData.self, from: safeData)
        completion(.success(userData))
      } catch {
        print("JSON Parsing Error:", error)
        completion(.failure(.parseError))
      }
    }.resume()
  }
}
