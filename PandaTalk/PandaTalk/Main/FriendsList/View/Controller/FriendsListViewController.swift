//
//  FriendListViewController.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift
import RxCocoa
import RxBinding
import RxOptional
import RxDataSources
import SkeletonView

class FriendsListViewController: BaseViewController<FriendsListViewModel> {
  
  private lazy var tableView = UITableView()
  
  let friendsObservable = Observable.of([
                                          Friend(name: "Red fox", profileImage: UIImage(), email: "fox@naver.com", uid: "WIEF123WDF"),
                                          Friend(name: "Polar bear", profileImage: UIImage(), email: "polarBear@naver.com", uid: "POLARBEAR"),
                                          Friend(name: "Cat", profileImage: UIImage(), email: "cat@gmail.com", uid: "CATUIDDUMMY")])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  func bind() {
    
  }
  
  func setupUI() {
    tableView.register(FriendsCell.self, forCellReuseIdentifier: FriendsCell.reuseIdentifier)
    tableView.rowHeight = 75
    tableView.delegate = self
    view.addSubview(tableView)
    friendsObservable.bind(to: tableView.rx.items(cellIdentifier: FriendsCell.reuseIdentifier, cellType: FriendsCell.self)) { row, element, cell in
      cell.friend = element
    }
    .disposed(by: disposeBag)

  }
  
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension FriendsListViewController: UITableViewDelegate {
  
}
