//
//  FriendFlow.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/06.
//

import RxFlow

enum FriendStep: Step {
  case start
}

class FriendFlow: Flow {
  
  var root: Presentable {
    friendListViewController
  }
  
  private let friendListViewController: FriendListViewController
  
  init() {
    friendListViewController = FriendListViewController(viewModel: .init())
  }
  
  private var navigationController: UINavigationController? {
    friendListViewController.navigationController
  }
  
  
  func navigate(to step: Step) -> FlowContributors {
    guard let friendStep = step as? FriendStep else {
      return .none
    }
    switch friendStep {
    case .start:
      return .viewController(friendListViewController)
    }
  }
}
