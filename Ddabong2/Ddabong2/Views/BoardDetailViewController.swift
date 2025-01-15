
import UIKit

class BoardDetailViewController: UIViewController {
    var board: Board? // 선택된 게시글 데이터

      // 뒤로가기 버튼
      private let backButton: UIButton = {
          let button = UIButton(type: .system)
          button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
          button.tintColor = .black
          button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
          button.translatesAutoresizingMaskIntoConstraints = false
          return button
      }()

      // 제목 레이블
      private let titleLabel: UILabel = {
          let label = UILabel()
          label.font = UIFont.boldSystemFont(ofSize: 20)
          label.textColor = .black
          label.numberOfLines = 0
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
      
      // 작성 시간 레이블
      private let timeAgoLabel: UILabel = {
          let label = UILabel()
          label.font = UIFont.systemFont(ofSize: 14)
          label.textColor = .gray
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
      
      // 구분선
      private let separatorView: UIView = {
          let view = UIView()
          view.backgroundColor = .lightGray
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()
      
      // 내용 레이블
      private let contentLabel: UILabel = {
          let label = UILabel()
          label.font = UIFont.systemFont(ofSize: 16)
          label.textColor = .darkGray
          label.numberOfLines = 0
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
      
      override func viewDidLoad() {
          super.viewDidLoad()
          setupUI()
          updateUI()
      }
      
      private func setupUI() {
          view.backgroundColor = .white
          view.addSubview(backButton)
          view.addSubview(titleLabel)
          view.addSubview(timeAgoLabel)
          view.addSubview(separatorView)
          view.addSubview(contentLabel)
          
          let horizontalMargin: CGFloat = 20 // 좌우 여백 설정
          
          NSLayoutConstraint.activate([
              // 뒤로가기 버튼
              backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin),
              backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
              backButton.widthAnchor.constraint(equalToConstant: 24),
              backButton.heightAnchor.constraint(equalToConstant: 24),
              
              // 제목 레이블
              titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
              titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin),
              titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalMargin),
              
              // 작성 시간 레이블
              timeAgoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
              timeAgoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
              timeAgoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
              
              // 구분선
              separatorView.topAnchor.constraint(equalTo: timeAgoLabel.bottomAnchor, constant: 8),
              separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
              separatorView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
              separatorView.heightAnchor.constraint(equalToConstant: 1),
              
              // 내용 레이블
              contentLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
              contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
              contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
              contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -horizontalMargin)
          ])
      }
      
      private func updateUI() {
          guard let board = board else { return }
          titleLabel.text = board.title
          contentLabel.text = board.content
          timeAgoLabel.text = board.timeAgo // timeAgo를 표시
      }
      
      // 뒤로가기 버튼 액션
      @objc private func didTapBackButton() {
          navigationController?.popViewController(animated: true)
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.setNavigationBarHidden(true, animated: false)
      }
}

