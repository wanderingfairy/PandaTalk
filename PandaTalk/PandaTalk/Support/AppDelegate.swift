//
//  AppDelegate.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import SnapKit
import RxSwift
import RxFlow
import Firebase
import Then

@_exported import RxBinding

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  private let coordinator = FlowCoordinator()
  private let disposeBag = DisposeBag()
  private let window = UIWindow()
  private let appModelInstance = AppModel.instance

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    
    coordinator.rx.didNavigate.subscribe(onNext: {
        print("did navigate to \($0) -> \($1)")
    }).disposed(by: disposeBag)
    
    //Login 분기 처리 필요
    appModelInstance.userModel.readCurrentUID { [unowned self] result in
      switch result {
      case .success(_):
        self.coordinate {
          (AppFlow(window: $0), AppStep.main)
        }
      case .failure(_):
        self.coordinate {
          (AppFlow(window: $0), AppStep.login)
        }
      }
    }
    return true
  }
  
  private func coordinate(to: (UIWindow) -> (Flow, Step)) {
    let (flow, step) = to(window)
    coordinator.coordinate(flow: flow, with: OneStepper(withSingleStep: step))
    window.makeKeyAndVisible()
  }
}

