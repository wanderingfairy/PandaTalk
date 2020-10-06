//
//  AppFlow.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/05.
//

import RxFlow

enum AppStep: Step {
  case login
  case main
}

class AppFlow: Flow {
  var root: Presentable {
    return rootWindow
  }
  
  private let rootWindow: UIWindow
  
  private lazy var navigationController = UINavigationController()
  
  init(window: UIWindow) {
    rootWindow = window
    rootWindow.backgroundColor = .white
    rootWindow.rootViewController = navigationController
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let appStep = step as? AppStep else {
      return  .none
    }
    
    switch appStep {
    case .login:
      let loginFlow = LoginFlow()
      Flows.use(loginFlow, when: .ready) { [unowned self] in
        self.navigationController.viewControllers = [$0]
      }
      return .flow(loginFlow, with: LoginStep.start)
    case .main:
      let mainFlow = MainFlow()
      Flows.use(mainFlow, when: .ready) { [unowned self] in
        self.navigationController.viewControllers = [$0]
      }
      return .flow(mainFlow, with: MainStep.start)
    }
  }
  
  
}
