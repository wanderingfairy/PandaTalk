//
//  SettingFlow.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/06.
//

import RxFlow

enum SettingStep: Step {
  case start
}

class SettingFlow: Flow {
  
  var root: Presentable {
    settingViewController
  }
  
  private let settingViewController: SettingViewController
  
  init() {
    settingViewController = SettingViewController(viewModel: .init())
  }
  
  private var navigationController: UINavigationController? {
    settingViewController.navigationController
  }
  
  
  func navigate(to step: Step) -> FlowContributors {
    guard let settingStep = step as? SettingStep else {
      return .none
    }
    switch settingStep {
    case .start:
      return .viewController(settingViewController)
    }
  }
}
