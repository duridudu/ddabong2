import UIKit

class BoardAllViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    // ViewModel 인스턴스
    private let viewModel = BoardAllViewModel()
   
    // 테이블 뷰
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // 검색 바
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요."
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // 검색 버튼
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 1.0) // #FF5B35
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var lastFetchedId: Int? // 무한 스크롤 및 검색 시 사용할 lastId
    private var isFetching: Bool = false // 중복 호출 방지

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.fetchAllBoards(size: 20, lastId: nil) // 초기 데이터 요청
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        // 제목 레이블
        let titleLabel = UILabel()
        titleLabel.text = "게시판"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // 뒤로가기 버튼
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        // 검색 스택뷰: 검색 바와 검색 버튼
        let searchStackView = UIStackView(arrangedSubviews: [searchBar, searchButton])
        searchStackView.axis = .horizontal
        searchStackView.alignment = .center
        searchStackView.spacing = 8
        searchStackView.translatesAutoresizingMaskIntoConstraints = false

        // 뷰에 추가
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(searchStackView)
        view.addSubview(tableView)

        // AutoLayout 설정
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            searchStackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            searchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalToConstant: 60),
            searchButton.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // 검색 버튼 클릭 이벤트
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        
        let inset: CGFloat = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)

        tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.identifier)
    }

    private func bindViewModel() {
        viewModel.onBoardsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.isFetching = false
                self?.tableView.reloadData()
            }
        }
    }

    @objc private func didTapSearchButton() {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            print("검색어가 비어 있습니다.")
            return
        }
        lastFetchedId = nil // 검색 초기화
        viewModel.fetchAllBoards(size: 20, lastId: lastFetchedId) // 검색 API 호출
    }

    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBoards().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.identifier, for: indexPath) as? BoardTableViewCell else {
            return UITableViewCell()
        }
        let board = viewModel.getBoards()[indexPath.row]
        cell.configure(with: board)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBoard = viewModel.getBoards()[indexPath.row]
        let detailVC = BoardDetailViewController()
        detailVC.board = selectedBoard
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // 스크롤 끝에 도달 시 데이터 요청
        if offsetY > contentHeight - frameHeight - 100 {
            guard !isFetching, viewModel.hasMoreData else { return } // 중복 호출 및 추가 데이터 여부 확인
            isFetching = true
            let lastId = UserSessionManager.shared.getLastFetchedId()
            viewModel.fetchAllBoards(size: 20, lastId: lastId)
        }
    }


}
