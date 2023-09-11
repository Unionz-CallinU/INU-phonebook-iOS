//
//  UIFontExtension.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/09/09.
//

import UIKit

extension UIImage {
  
  public var base64: String {
    return self.jpegData(compressionQuality: 1.0)!.base64EncodedString()
  }
  
  convenience init?(base64: String, withPrefix: Bool) {
    var finalData: Data?
    
    if withPrefix {
      guard let url = URL(string: base64) else { return nil }
      finalData = try? Data(contentsOf: url)
    } else {
      finalData = Data(base64Encoded: base64)
    }
    
    guard let data = finalData else { return nil }
    self.init(data: data)
  }
}
