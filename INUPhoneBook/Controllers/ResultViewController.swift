//
//  ResultViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/02.
//

import UIKit

import DropDown
import SnapKit

final class ResultViewController: NaviHelper {
  
  let userManager = UserManager.shared
  var searchKeyword: String?
  
  let categories = ["카테고리1", "카테고리2", "카테고리3", "카테고리4"]
  var selectedCategory: String?
  
  init(searchKeyword: String) {
    self.searchKeyword = searchKeyword
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let mainTitle: UILabel = {
    let label = UILabel()
    label.text = "검색결과"
    label.font = UIFont.systemFont(ofSize: 24)
    return label
  }()
  
  private let searchController: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "상세정보를 입력하세요"
    bar.backgroundImage = UIImage()
    return bar
  }()
  
  private let resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellId)
    return tableView
  }()
  
  private var alertTextField: UITextField!
  
  private var arrowDown: UIButton = {
    let arrow = UIButton()
    let img = UIImage(named: "Left")
    arrow.setImage(img, for: .normal)
    arrow.sizeToFit()
    arrow.addTarget(self, action: #selector(showCategoryList), for: .touchUpInside)
    return arrow
  }()
  
  lazy var pickerView: UIPickerView = {
    let picker = UIPickerView()
    picker.delegate = self
    picker.dataSource = self
    return picker
  }()
  
  private func configureAlertTextField() {
    alertTextField = UITextField()
    alertTextField.placeholder = "기본"
    alertTextField.rightView = arrowDown
    alertTextField.rightViewMode = .always
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    setupLayout()
    makeUI()
    
    searchController.delegate = self
    navigationItemSetting()
    
    resultTableView.delegate = self
    resultTableView.dataSource = self
    
  }
  
  // MARK: - view 계층 구성
  func setupLayout(){
    [
      searchController,
      resultTableView,
      mainTitle
    ].forEach {
      view.addSubview($0)
    }
  }
  // MARK: - UI세팅
  func makeUI() {
    mainTitle.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(searchController.snp.top).offset(-20)
    }
    
    searchController.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(60)
    }
    
    resultTableView.snp.makeConstraints { (make) in
      make.top.equalTo(searchController.snp.bottom).offset(70)
      make.left.right.bottom.equalToSuperview()
    }
  }
}

// MARK: - cell 함수
extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.userManager.getUsersFromAPI().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                                   for: indexPath) as! CustomCell
    
    let user = userManager.getUsersFromAPI()[indexPath.row]
    let starImage = user.isSaved == true ? UIImage(named: "StarChecked") : UIImage(named: "Star")
    
    cell.name.text = user.name
    cell.email.text = user.email
    cell.college.text = user.college
    cell.phoneNum.text = user.phoneNumber
    cell.profile.image = UIImage(named: "INU1")!
    cell.star.setImage(starImage, for: .normal)
    cell.user = user
    
    cell.saveButtonPressed = { [weak self] (senderCell, isSaved) in
      guard let self = self else { return }
      if !isSaved {
        self.makeMessageAlert{ savedAction, title  in
          if savedAction {
            self.userManager.saveUserData(with: user) {
              senderCell.user?.isSaved = true
              senderCell.setButtonStatus()
              print("저장됨")
            }
          } else {
            print("취소됨")
            print(user.isSaved)
          }
        }
      } else {
        self.makeRemoveCheckAlert { removeAction in
          if removeAction {
            self.userManager.deleteUser(with: user) {
              senderCell.user?.isSaved = false
              senderCell.setButtonStatus()
              print("저장된 것 삭제")
            }
          } else {
            print("저장된 것 삭제하기 취소됨")
          }
        }
      }
    }
    cell.selectionStyle = .none
    return cell
  }
  
  // UITableViewDelegate 함수 (선택)
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = userManager.getUsersFromAPI()[indexPath.row]
    let detailVC = DetailViewController()
    detailVC.userData = [selectedItem] // 선택된 아이템 데이터를 전달합니다.
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}

// MARK: - Alert 함수
extension ResultViewController {
  
  func makeMessageAlert(completion: @escaping (Bool, String?) -> Void) {
    let alert = UIAlertController(title: "저장?",
                                  message: "저장할 카테고리를 선택해 주세요:",
                                  preferredStyle: .alert)
    
    alert.addTextField { [self] (textField) in
      textField.placeholder = "기본"
      textField.rightView = self.arrowDown
      textField.rightViewMode = .always
      self.alertTextField = textField
      
      // arrowDown 버튼이 눌렸을 때의 액션 설정
      self.arrowDown.addTarget(self, action: #selector(showCategoryList), for: .touchUpInside)
    }
    
    let ok = UIAlertAction(title: "확인",
                           style: .default) { okAction in
      let selectedCategory = alert.textFields?.first?.text
      completion(true, selectedCategory)
    }
    
    let cancel = UIAlertAction(title: "취소",
                               style: .cancel) { cancelAction in
      completion(false, nil)
    }
    
    alert.addAction(cancel)
    alert.addAction(ok)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc func showCategoryList() {
      // inputAccessoryView 설정
      let pickerViewToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
      pickerViewToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(hidePickerView))]
      
      self.alertTextField.inputAccessoryView = pickerViewToolbar

      // pickerView 위치 조정
      self.pickerView.frame = CGRect(x: 0, y: self.view.frame.size.height - self.pickerView.frame.size.height, width: self.view.frame.size.width, height: self.pickerView.frame.size.height)

      // inputView 및 inputAccessoryView를 설정한 후 재로드
      self.alertTextField.inputView = self.pickerView
      self.alertTextField.reloadInputViews()
  }

  @objc func hidePickerView() {
      self.alertTextField.resignFirstResponder()
  }

  // 화면을 터치하면 pickerView 숨기기
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.alertTextField.resignFirstResponder()
  }

  func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
    let alert = UIAlertController(title: "삭제?",
                                  message: "정말 저장된거 지우시겠습니까?",
                                  preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인",
                           style: .default) { okAction in
      completion(true)
    }
    let cancel = UIAlertAction(title: "취소",
                               style: .cancel) { cancelAction in
      completion(false)
    }
    alert.addAction(ok)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
  

}

// MARK: - 서치바 함수
extension ResultViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text else { return }
    let searchResultController = ResultViewController(searchKeyword: keyword)
    
    userManager.fetchUsersFromAPI(with: keyword) { [self] in
      DispatchQueue.main.async { [self] in
        navigationController?.pushViewController(searchResultController, animated: true)
      }
    }
  }
  
}

// MARK: - pickerview 함수
extension ResultViewController: UIPickerViewDelegate,
                                UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    return categories.count
  }
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {
    return categories[row]
  }
  
  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    selectedCategory = categories[row]
  }
}
