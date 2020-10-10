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
  
  private var isSignUpFlow = false
  
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
    $0.setKeyboardType = .emailAddress
  }
  
  private lazy var passwordTextField = FloatingPlaceholderTextField().then {
    $0.setPlaceholderText = "Password"
    $0.backgroundColor = .white
    $0.setTextInputClearButtonMode = .unlessEditing
    $0.setIsSecureMode = true
    $0.setTextContentType = .oneTimeCode
  }
  
  private lazy var passwordVerifyTextField = FloatingPlaceholderTextField().then {
    $0.setPlaceholderText = "Retype password"
    $0.backgroundColor = .white
    $0.setTextInputClearButtonMode = .unlessEditing
    $0.setIsSecureMode = true
    $0.setTextContentType = .oneTimeCode
    $0.alpha = 0
  }
  
  private lazy var signInButton = MDCButton().then {
    $0.setTitle("Sign in", for: .normal)
  }
  
  private lazy var signUpButton = MDCButton().then {
    $0.setTitle("Sign up", for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
    addSubviews()
    setUpUI()
    setUpConstraints()
    binding()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.checkUserLoginStatus()
  }
  
  //MARK: - Override Bind() from RxController
  override func bind() -> [Disposable] {
    return [
      emailTextField.textSubject.distinctUntilChanged() ~> viewModel.emailTextSubject,
      passwordTextField.textSubject.distinctUntilChanged() ~> viewModel.passwordTextSubject,
      passwordVerifyTextField.textSubject.distinctUntilChanged() ~> viewModel.retypePasswordTextSubject
    ]
  }
  
  override func subviews() -> [UIView] {
    [scrollView]
  }
  
  private func binding() {
    viewModel.viewModelStart()
    
    //password 비교 검증
    Observable.combineLatest(viewModel.passwordTextSubject, viewModel.retypePasswordTextSubject) { [unowned self] password, retype -> Observable<Bool> in
      let observableTuple = Observable<Bool>.create { (observer) -> Disposable in
        if password.count >= 8 && retype.count == 0 {
          self.viewModel.passwordIsEqualToRetypePasswordSubject.onNext(false)
          observer.onNext(true)
        } else if password.count >= 8 && password != retype {
          self.viewModel.passwordIsEqualToRetypePasswordSubject.onNext(false)
          observer.onNext(false)
        } else if password.count >= 8 && retype == password {
          self.viewModel.passwordIsEqualToRetypePasswordSubject.onNext(true)
        observer.onNext(true)
        }
        return Disposables.create()
      }
      return observableTuple
    }
    .observeOn(MainScheduler.instance)
    .subscribe (onNext: { [unowned self] bool in
      bool.bind { correct in
        correct ? self.passwordVerifyTextField.removeErrorText() : self.passwordVerifyTextField.makeRetypePasswordTextFieldError()
      }
      .disposed(by: disposeBag)
    })
    .disposed(by: disposeBag)

    
    signInButton.rx.tap
      .bind { [unowned self] in
        self.hideSignUpFlow()
        print("SignInButton Tapped")
        
        //로그인 상태이고, 올바른 이메일 & 패스워드일 때 로그인 요청
        if !isSignUpFlow {
        self.viewModel.canSignInSubject
          .takeWhile { $0 == true }
          .bind { bool in
            if bool {
              print("didTapSignIpButton() is run in LoginVC")
              self.viewModel.didTapSignInButton()
            }
          }
          .disposed(by: disposeBag)
        }
      }
      .disposed(by: disposeBag)
    
    
    
    signUpButton.rx.tap
      .bind { [unowned self] in
        self.showSignUpFlow()
        print("SignUpButton Tapped")
        
        //회원가입 상태이고, 올바른 이메일 & 패스워드일 때 회원가입 요청
        if isSignUpFlow {
        self.viewModel.canSignUpSubject
          .takeWhile { $0 == true }
          .bind {
            if $0 {
              print("didTapSignUpButton() is run in LoginVC")
              self.viewModel.didTapSignUpButton()
            }
          }
          .disposed(by: disposeBag)
        }
      }
      .disposed(by: disposeBag)
    
    viewModel.checkCanSignIn()
    viewModel.checkCanSignUp()
    
    //회원가입 조건 이메일 & 비밀번호 검증 통과
    viewModel.canSignUpSubject
      .bind { print("canSignUpSubject is ", $0) }
      .disposed(by: disposeBag)
    
    //로그인 조건 이메일 & 비밀번호 검증 통과
    viewModel.canSignInSubject
      .bind { print("canSignInSubject is ", $0)}
      .disposed(by: disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [scrollView] keyboardVisibleHeight in
        if scrollView.contentInset.bottom != keyboardVisibleHeight {
        scrollView.contentInset.bottom = keyboardVisibleHeight
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  private func addSubviews() {
//    view.addSubviews(views: [scrollView])
    scrollView.addSubview(contentView)
    contentView.addSubviews(views: [emailTextField, passwordVerifyTextField, passwordTextField, signUpButton, signInButton])
  }
  
  private func setUpUI() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTouch))
    scrollView.addGestureRecognizer(tapGestureRecognizer)
    
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
    passwordVerifyTextField.snp.makeConstraints { $0.top.equalTo(emailTextField.snp.bottom).offset(30)
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(emailTextField)
      $0.trailing.equalTo(emailTextField)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(30)
      $0.centerX.equalToSuperview()
      $0.leading.equalTo(emailTextField)
      $0.trailing.equalTo(emailTextField)
    }
    
    signInButton.snp.makeConstraints {
      $0.top.equalTo(passwordVerifyTextField.snp.bottom).offset(30).priority(.medium)
      $0.trailing.equalTo(passwordTextField)
      $0.width.equalTo(passwordTextField).multipliedBy(0.3)
      $0.height.equalTo(passwordTextField.snp.width).multipliedBy(0.15)
    }
    
    signUpButton.snp.makeConstraints {
      $0.top.equalTo(passwordVerifyTextField.snp.bottom).offset(30).priority(.medium)
      $0.trailing.equalTo(signInButton.snp.leading).offset(-30)
      $0.width.equalTo(passwordTextField).multipliedBy(0.3)
      $0.height.equalTo(passwordTextField.snp.width).multipliedBy(0.15)
    }
    
    contentView.snp.makeConstraints {
      $0.bottom.greaterThanOrEqualTo(signInButton)
    }
  }
  
  //MARK: - Handle TapGesture
  @objc func didTapTouch(sender: UIGestureRecognizer) {
    view.endEditing(true)
  }
  
  //MARK: - Handle UIAnimation
  private func showSignUpFlow() {
    if !isSignUpFlow {
      isSignUpFlow.toggle()
      self.view.layoutIfNeeded()
      
      passwordVerifyTextField.snp.remakeConstraints {
        $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
        $0.centerX.equalToSuperview()
        $0.leading.equalTo(emailTextField)
        $0.trailing.equalTo(emailTextField)
      }
      
      contentView.snp.remakeConstraints {
        $0.top.leading.trailing.bottom.equalToSuperview()
        $0.centerX.equalToSuperview()
        $0.bottom.greaterThanOrEqualTo(signInButton)
      }
      
      UIView.animate(withDuration: 0.5) {
        self.passwordVerifyTextField.alpha = 1
        self.view.layoutIfNeeded()
      }
    }
  }
  
  private func hideSignUpFlow() {
    if isSignUpFlow {
      isSignUpFlow.toggle()
      
      self.view.layoutIfNeeded()
      
      passwordVerifyTextField.snp.remakeConstraints { $0.top.equalTo(emailTextField.snp.bottom).offset(30)
        $0.centerX.equalToSuperview()
        $0.leading.equalTo(emailTextField)
        $0.trailing.equalTo(emailTextField)
      }
      
      contentView.snp.remakeConstraints {
        $0.top.leading.trailing.bottom.equalToSuperview()
        $0.centerX.equalToSuperview()
        $0.bottom.greaterThanOrEqualTo(signInButton)
      }
      
      UIView.animate(withDuration: 0.5) {
        self.passwordVerifyTextField.alpha = 0
        self.view.layoutIfNeeded()
      }
    }
  }
  
}
