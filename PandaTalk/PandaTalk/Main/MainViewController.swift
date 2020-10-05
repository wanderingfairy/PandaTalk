//
//  MainViewController.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/05.
//

import RxSwift

enum MainTabType: Int {
  case friendList = 0
  case chatList = 1
  case setting = 2
  
  var tabTitle: String? {
    switch self {
    case .friendList:
      return "Friends"
    case .chatList:
      return "Chats"
    case .setting:
      return "Setting"
    }
  }
  
  var navigationTitle: String? {
    switch self {
    case .friendList:
      return "Friend List"
    case .chatList:
      return "Chat List"
    case .setting:
      return "Setting"
    }
  }
}

class MainViewController: UITabBarController {
  
  private let disposeBag = DisposeBag()
  private let viewModel: MainViewModel
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var viewControllers: [UIViewController]? {
    didSet {
      guard let viewControllers = viewControllers, viewControllers.count > 0 else {
        return
      }
      for (index, viewController) in viewControllers.enumerated() {
        let type = MainTabType(rawValue: index)
        viewController.tabBarItem = UITabBarItem(title: type?.tabTitle, image: nil, tag: index)
      }
      updateNavigationBar(with: .friendList)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
    // Do any additional setup after loading the view.
  }
  
  private func updateNavigationBar(with type: MainTabType) {
    title = type.navigationTitle
  }
  
  
}

extension MainViewController: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    guard let tabType = MainTabType(rawValue: tabBarController.selectedIndex) else {
      return
    }
    updateNavigationBar(with: tabType)
  }
  
}
