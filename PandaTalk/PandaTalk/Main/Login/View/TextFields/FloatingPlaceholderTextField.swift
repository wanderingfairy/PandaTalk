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
  
  override func layoutSubviews() {
    
    setupInputView()
    setupContoller()
    
  }
}

extension FloatingPlaceholderTextField: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textSubject.accept(textField.text!)
    textField.resignFirstResponder()
    
    return true
  }
}
