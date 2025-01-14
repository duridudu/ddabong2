import UIKit
import Alamofire

class BoardAllViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // ViewModel 인스턴스
    private let viewModel = BoardViewModel()
   
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // 볼드 처리
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var lastFetchedId: Int? // 무한 스크롤 및 검색 시 사용할 lastId

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.fetchBoards(size: 20) // 초기 데이터 요청 (예: 20개 게시물)
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        // 제목 레이블 (중앙 정렬)
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

        // 검색 스택뷰: 검색바와 검색 버튼
        let searchStackView = UIStackView(arrangedSubviews: [searchBar, searchButton])
        searchStackView.axis = .horizontal
        searchStackView.alignment = .center
        searchStackView.spacing = 8
        searchStackView.translatesAutoresizingMaskIntoConstraints = false

        // 테이블뷰 추가
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(searchStackView)
        view.addSubview(tableView)

        // AutoLayout 설정
        NSLayoutConstraint.activate([
            // 뒤로가기 버튼
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            // 제목 레이블 (화면 중앙 배치)
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            // 검색 스택뷰
            searchStackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            searchStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalToConstant: 60),
            searchButton.heightAnchor.constraint(equalToConstant: 40),

            // 테이블뷰
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
        tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.onBoardsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // 검색 버튼 액션
    @objc private func didTapSearchButton() {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            print("검색어가 비어 있습니다.")
            viewModel.resetSearch() // 검색어 없으면 일반 데이터로 리셋
            return
        }
        lastFetchedId = nil // 검색 시 초기화
        viewModel.searchBoards(word: searchText, size: 20, lastId: lastFetchedId)
    }

    // 뒤로가기 버튼 액션
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    // TableView DataSource
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
        
        // 선택된 게시글 가져오기
        let selectedBoard = viewModel.getBoards()[indexPath.row]
        
        // BoardDetailViewController로 이동
        let detailVC = BoardDetailViewController()
        detailVC.board = selectedBoard // 선택된 게시글 데이터 전달
        navigationController?.pushViewController(detailVC, animated: true)
    }

   
}
