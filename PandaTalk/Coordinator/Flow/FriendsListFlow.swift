//
//  FriendFlow.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/06.
//

import RxFlow

enum FriendsListStep: Step {
  case start
}

class FriendsListFlow: Flow {
  
  var root: Presentable {
    friendsListViewController
  }
  
  private let friendsListViewController: FriendsListViewController
  
  init() {
    friendsListViewController = FriendsListViewController(viewModel: .init())
  }
  
  private var navigationController: UINavigationController? {
    friendsListViewController.navigationController
  }
  
  
  func navigate(to step: Step) -> FlowContributors {
    guard let friendsListStep = step as? FriendsListStep else {
      return .none
    }
    switch friendsListStep {
    case .start:
      return .viewController(friendsListViewController)
    }
  }
}
