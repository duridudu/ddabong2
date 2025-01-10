
//JH


import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.fetchBoards()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "게시판"
        
        // 검색 UI 추가
        view.addSubview(searchBar)
        view.addSubview(searchButton)
        
        // 테이블 뷰 추가
        view.addSubview(tableView)
        
        // 검색 UI AutoLayout 설정
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: 60),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            // 테이블 뷰 AutoLayout 설정
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BoardAllCell")
    }
    
    private func bindViewModel() {
        viewModel.onBoardsFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.onError = { error in
            print("Error: \(error)")
        }
    }
    
    // MARK: - 검색 버튼 액션
    @objc private func didTapSearchButton() {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            print("검색어가 비어 있습니다.")
            return
        }
        print("검색 실행: \(searchText)")
        // 검색 로직 추가 가능 (예: viewModel.filterBoards(by: searchText))
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardAllCell", for: indexPath)
        let board = viewModel.boards[indexPath.row]
        cell.textLabel?.text = board.title
        cell.detailTextLabel?.text = board.createdAt
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBoard = viewModel.boards[indexPath.row]
        let detailVC = BoardDetailViewController()
        detailVC.board = selectedBoard
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //여백삭제
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.setNavigationBarHidden(true, animated: false)
       }

}


//프리뷰~~~~~~~~~~~~~~~~~

import SwiftUI

struct BoardAllViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let boardAllVC = BoardAllViewController()
            return UINavigationController(rootViewController: boardAllVC)
        }
    }
}
