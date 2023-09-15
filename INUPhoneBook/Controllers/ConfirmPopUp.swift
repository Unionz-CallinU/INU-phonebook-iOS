import UIKit

class CustomPopupViewController: UIViewController {
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font =  UIFont(name: "Pretendard", size: 20)
    return label
  }()
  
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.font =  UIFont(name: "Pretendard", size: 14)
    return label
  }()
  
  let confirmButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("확인", for: .normal)
    btn.setTitleColor(UIColor.white, for: .normal)
    btn.backgroundColor = UIColor.blue
    btn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    btn.roundedButton()
    return btn
  }()

  let popupView : UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white
    view.layer.cornerRadius = 15
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
  
    setupLayout()

    view.addSubview(popupView)

    makeUI()
    
  }
  
  @objc private func confirmButtonTapped() {
    dismiss(animated:true, completion:nil)
  }
  
  func setupLayout(){
    [
      titleLabel,
      descriptionLabel,
      confirmButton
    ].forEach {
      popupView.addSubview($0)
    }
  }
  
  func makeUI(){
    let maskLayer = CAShapeLayer()
    let rectShape = CAShapeLayer()

    rectShape.bounds = confirmButton.bounds
    rectShape.position = confirmButton.center
    rectShape.path = UIBezierPath(roundedRect: confirmButton.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath

    maskLayer.path = rectShape.path
    
    popupView.snp.makeConstraints { make in
      make.width.equalTo(252)
      make.height.equalTo(140)
      make.centerY.centerX.equalToSuperview()
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.centerX.equalToSuperview()
    }
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(-10)
      make.centerX.equalToSuperview()
    }
    confirmButton.snp.makeConstraints { make in
      make.centerX.bottom.equalToSuperview()
      make.width.equalTo(popupView)
      make.top.equalTo(descriptionLabel.snp.bottom)
      make.height.equalTo(popupView.snp.height).multipliedBy(1.0/3.0)
    }
  }
}

extension UIButton {
  func roundedButton(){
    clipsToBounds = true
    layer.cornerRadius = 10
    layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
}
