//
//  FloatingPlaceholderTextField.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/06.
//

import RxSwift
import RxCocoa
import RxBinding
import MaterialComponents.MaterialTextFields

class FloatingPlaceholderTextField: UIView {
  private var textInput: MDCTextField!
  private var controller: MDCTextInputControllerOutlined!
  
  var disposeBag = DisposeBag()
  
  private let textColor = UIColor.black
  private var clearButtonMode = UITextField.ViewMode.never
  private var isSecureMode = false
  private var keyboardType = UIKeyboardType.default
  private var textContentType = UITextContentType.oneTimeCode
  
  private var placeHolderText = ""
  
  let textSubject = BehaviorRelay<String>(value: "")
  
  var setTextContentType: UITextContentType {
    get {
      return textContentType
    }
    set(type) {
      textContentType = type
    }
  }
  
  var setPlaceholderText: String {
    get{
      return placeHolderText
    }
    set(str){
      placeHolderText = str
    }
  }
  
  var setTextInputClearButtonMode: UITextField.ViewMode {
    get {
      return clearButtonMode
    }
    set(mode) {
      clearButtonMode = mode
    }
  }
  
  var setIsSecureMode: Bool {
    get {
      return isSecureMode
    }
    set(bool) {
      isSecureMode = bool
    }
  }
  
  var setKeyboardType: UIKeyboardType {
    get {
      return keyboardType
    }
    set(type) {
      keyboardType = type
    }
  }
  
  private func setupInputView() {
    
    if let _ = self.viewWithTag(1){return}
    
    textInput = MDCTextField()
    
    textInput.tag = 1
    textInput.clearButtonMode = clearButtonMode
    textInput.isSecureTextEntry = isSecureMode
    textInput.keyboardType = keyboardType
    textInput.textContentType = textContentType
    
    self.addSubview(textInput)
    textInput.placeholder = placeHolderText
    textInput.delegate = self
    textInput.textColor = textColor
    
    textInput.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupContoller(){
    // MARK: Text Input Controller Setup
    
    // Step 1
    controller = MDCTextInputControllerOutlined(textInput: textInput)
    
    // Step 2
    controller.activeColor = textColor
    controller.normalColor = textColor
    controller.textInput?.textColor = textColor
    controller.inlinePlaceholderColor = textColor
    controller.floatingPlaceholderActiveColor = textColor
    controller.floatingPlaceholderNormalColor = textColor
  }
  
  func bindTextField() {
    if (textInput != nil && controller != nil) {
      // When password is wrong
      textInput.rx.text
        .replaceNilWith("")
        .filter { [unowned self] _ in
          self.placeHolderText == "Password"
        }
        .filter { $0.count < 8 && $0.count > 0}
        .bind { [unowned self] _ in
          textSubject.accept("")
          controller.setErrorText("Password is too short",
                                  errorAccessibilityValue: nil)
        }
        .disposed(by: disposeBag)
      
      // When password is correct
      textInput.rx.text
        .replaceNilWith("")
        .filter { [unowned self] _ in
          self.placeHolderText == "Password"
        }
        .filter { $0.count >= 8}
        .bind { [unowned self] text in
          textSubject.accept(text)
          controller.setErrorText(nil, errorAccessibilityValue:nil)
        }
        .disposed(by: disposeBag)
      
      // Retype password일 때 텍스트 입력시 accept
      textInput.rx.text
        .replaceNilWith("")
        .filter { [unowned self] _ in
          self.placeHolderText == "Retype password"
        }
        .bind { [unowned self] text in
          textSubject.accept(text)
        }
        .disposed(by: disposeBag)
      
      //이메일 잘못된 형식일 때
      textInput.rx.text
        .replaceNilWith("")
        .filter { [unowned self] text in
          self.placeHolderText == "Email" && text.count > 0 && !isValidEmail(testStr: text)
        }
        .bind { [unowned self] text in
          textSubject.accept("")
          controller.setErrorText("Wrong email", errorAccessibilityValue: nil)
        }
        .disposed(by: disposeBag)
      
      // 올바른 이메일 형식일 때
      textInput.rx.text
        .replaceNilWith("")
        .filter { [unowned self] text in
          self.placeHolderText == "Email" && isValidEmail(testStr: text)
        }
        .bind { [unowned self] text in
          textSubject.accept(text)
          controller.setErrorText(nil, errorAccessibilityValue: nil)
        }
        .disposed(by: disposeBag)
    }
  }
  
  func makeRetypePasswordTextFieldError() {
//      print(#function)
      controller.setErrorText("Password does not match", errorAccessibilityValue: nil)
  }
  
  func removeErrorText() {
//    print(#function)
    controller.setErrorText(nil, errorAccessibilityValue: nil)
  }
  
  override func layoutSubviews() {
    
    setupInputView()
    setupContoller()
    bindTextField()
  }
}

extension FloatingPlaceholderTextField: UITextFieldDelegate {
  //  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
  //    textField.resignFirstResponder()
  //
  //
  //    return true
  //  }
  //
  //  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
  //    if (placeHolderText == "Password") {
  //    let textFieldCharacterCount = textField.text?.count ?? 0
  //          if (textFieldCharacterCount < 8) {
  //            controller.setErrorText("Password is too short",
  //                                                   errorAccessibilityValue: nil)
  //          } else {
  //            textSubject.accept(textField.text!)
  //            controller.setErrorText(nil, errorAccessibilityValue:nil)
  //       }
  //    }
  //    return true
  //  }
}

