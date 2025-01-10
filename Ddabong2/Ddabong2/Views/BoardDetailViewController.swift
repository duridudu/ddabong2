import UIKit

class BoardDetailViewController: UIViewController {
    
    var board: Board? // BoardViewModel에서 전달받은 게시글 데이터

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal) // 뒤로가기 화살표 아이콘
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside) // 클릭 이벤트 연결
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }

    /// UI 설정
    private func setupUI() {
        view.backgroundColor = .white
        
        // 서브뷰 추가
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        
        // 오토레이아웃 설정
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 뒤로가기 버튼
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 제목 레이블
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // 날짜 레이블
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    /// 데이터 구성
    private func configureUI() {
        guard let board = board else { return }
        titleLabel.text = board.title
        dateLabel.text = board.createdAt
    }
    
    /// 뒤로가기 버튼 액션
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    // 여백 삭제
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

