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
import RxKeyboard
import MaterialComponents.MaterialTextFields

class LoginViewController: BaseViewController<LoginViewModel> {
    
  private lazy var scrollView = UIScrollView().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
  
  private lazy var contentView = UIView()
  
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
    setUpUI()
    setUpConstraints()
    binding()
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
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [scrollView] keyboardVisibleHeight in
        scrollView.contentInset.bottom = keyboardVisibleHeight
      })
      .disposed(by: disposeBag)
    
  }
  
  private func addSubViews() {
    view.addSubViews(views: [scrollView])
    scrollView.addSubview(contentView)
    contentView.addSubViews(views: [emailTextField, passwordTextField, signInButton])
  }
  
  private func setUpUI() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTouch))
    scrollView.addGestureRecognizer(tapGestureRecognizer)
    
//    registerKeyboardNotifications()
  }
  
  private func setUpConstraints() {
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    emailTextField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(30)
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(emailTextField)
      $0.trailing.equalTo(emailTextField)
    }

    signInButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
      $0.trailing.equalTo(passwordTextField)
      $0.width.equalTo(passwordTextField).multipliedBy(0.3)
      $0.height.equalTo(passwordTextField.snp.width).multipliedBy(0.15)
    }
    
    contentView.snp.makeConstraints {
      $0.bottom.greaterThanOrEqualTo(signInButton)
    }
  }
  
  @objc func didTapTouch(sender: UIGestureRecognizer) {
    view.endEditing(true)
  }
  
}

extension UIView {
  func addSubViews(views: [UIView]) {
    views.forEach {
      self.addSubview($0)
    }
  }
}

