//
//  LoginFlow.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/06.
//

import RxFlow

enum LoginStep: Step {
  case start
  case loginComplete
//  case signInComplete
}

class LoginFlow: Flow {
  
  var root: Presentable {
    loginViewController
  }
  
  private let loginViewController: LoginViewController
  
  init() {
    loginViewController = LoginViewController(viewModel: .init())
  }
  
  private var navigationController: UINavigationController? {
    loginViewController.navigationController
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let loginStep = step as? LoginStep else {
      return .none
    }
    switch loginStep {
    case .start:
      return .viewController(loginViewController)
    case .loginComplete:
      
      return .end(forwardToParentFlowWithStep: AppStep.main)
    }
  }
}
