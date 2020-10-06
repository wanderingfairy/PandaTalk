//
//  LoginViewController.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift
import RxCocoa
import RxBinding
import RxController
import MaterialComponents.MaterialTextFields

class LoginViewController: BaseViewController<LoginViewModel> {
  
  private lazy var scrollView = UIScrollView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
  
  private lazy var emailTextField = FloatingPlaceholderTextField().then {
    $0.setPlaceholderText = "Email"
    $0.backgroundColor = .white
    $0.setTextInputClearButtonMode = .unlessEditing
  }
  
  private lazy var passwordTextField = FloatingPlaceholderTextField().then {
    $0.setPlaceholderText = "Password"
    $0.backgroundColor = .white
    $0.setTextInputClearButtonMode = .unlessEditing
    $0.setIsSecureMode = true
  }
  
  private lazy var signInButton = MDCButton().then {
    $0.setTitle("Sign in", for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
    addSubViews()
    binding()
    setUpUI()
    setUpConstraints()
  }
  
  //MARK: - Override Bind() in RxController
  override func bind() -> [Disposable] {
    return [
      emailTextField.textSubject ~> viewModel.emailTextSubject,
      passwordTextField.textSubject ~> viewModel.passwordTextSubject
    ]
  }
  
  private func binding() {
    //Check inject TextField text to Subject in ViewModel
    viewModel.emailTextSubject
      .subscribe(onNext: {
                  print("currentText is", $0)
      })
      .disposed(by: disposeBag)
    
    signInButton.rx.tap
      .bind { [unowned self] in
        self.viewModel.didTapSignInButton()
        print("buttonTap")
      }
      .disposed(by: disposeBag)
  }
  
  private func addSubViews() {
    view.addSubViews(views: [scrollView])
    scrollView.addSubViews(views: [emailTextField, passwordTextField, signInButton])
  }
  
  private func setUpUI() {
    
  }
  
  private func setUpConstraints() {
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    emailTextField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(50)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.87)
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(50)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.87)
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    
    signInButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(50)
      $0.trailing.equalTo(passwordTextField)
      $0.width.equalTo(passwordTextField).multipliedBy(0.3)
      $0.height.equalTo(passwordTextField)
    }
  }
}

extension UIView {
  func addSubViews(views: [UIView]) {
    views.forEach {
      self.addSubview($0)
    }
  }
}

