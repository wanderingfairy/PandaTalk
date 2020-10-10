//
//  FriendsListTableViewCell.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/10.
//

import RxSwift
import RxCocoa
import RxBinding
import RxOptional
import RxDataSources
import SkeletonView

class FriendsCell: UITableViewCell {
  
  static let reuseIdentifier = "FriendsCell"
  
  var friend: Friend? {
    didSet {
      configureCell()
    }
  }
  
  private lazy var profileImageView = UIImageView().then {
    $0.isSkeletonable = true
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private lazy var friendNameLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 18)
  }
  
  private lazy var friendEmailLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.textColor = .lightGray
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(profileImageView)
    selectedBackgroundView?.isHidden = true
    profileImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
      $0.width.height.equalTo(56)
    }
    profileImageView.layer.cornerRadius = 56 / 2
    
    let stack = UIStackView(arrangedSubviews: [friendNameLabel, friendEmailLabel])
    stack.axis = .vertical
    stack.spacing = 2
    
    addSubview(stack)
    stack.snp.makeConstraints {
        $0.centerY.equalTo(profileImageView)
        $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
    }
  }
  
  private func configureCell() {
      guard let friend = friend else { return }
//      let url = URL(string: user.profileImageUrl)
//      profileImageView.sd_setImage(with: url)
    profileImageView.image = friend.profileImage //후에 kingFisher 통해서 url로 변경하기
    profileImageView.showSkeleton() //url로 바뀌면 지우기
    friendNameLabel.text = friend.name
    friendEmailLabel.text = friend.email
  }
  
}
