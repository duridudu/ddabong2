import UIKit

class AdminUserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private var users: [UserListItem] = []
    private var filteredUsers: [UserListItem] = []
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserList()
    }
    
    // MARK: - UI 초기화
    private func setupUI() {
        view.backgroundColor = .white
        
        
        // 상단 타이틀 영역 설정
        setupCustomHeader()
        
        // 검색창 설정
        setupSearchBar()
        
        // 테이블 뷰 설정
        setupTableView()
    }
    
    
    private func setupCustomHeader() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        
        // 뒤로가기 버튼
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        let titleLabel = UILabel()
        titleLabel.text = "회원 목록"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
            headerView.addSubview(backButton)
            headerView.addSubview(titleLabel)

        // Auto Layout 설정
           NSLayoutConstraint.activate([
               headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               headerView.heightAnchor.constraint(equalToConstant: 50),

               backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
               backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
               backButton.widthAnchor.constraint(equalToConstant: 30),
               backButton.heightAnchor.constraint(equalToConstant: 30),

               titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
               titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
           ])
    }
    
    private func setupSearchBar() {
        // 검색창 기본 설정
        searchBar.placeholder = "이름, 사번 또는 소속을 입력하세요."
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal // 구분선 제거
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        // 커스텀 스타일 추가
        searchBar.searchTextField.backgroundColor = UIColor(white: 0.99, alpha: 1.0) // 매우 밝은 회색
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.clearButtonMode = .whileEditing // 텍스트 삭제 버튼 표시
        searchBar.searchTextField.leftView?.tintColor = .gray // 돋보기 아이콘 색상

        view.addSubview(searchBar)

        // Auto Layout 설정
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), // 왼쪽 마진
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), // 오른쪽 마진
            searchBar.heightAnchor.constraint(equalToConstant: 50) // 통통한 높이
        ])
    }

    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.separatorStyle = .none // 구분선 제거
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - 데이터 로드
    private func fetchUserList() {
        AdminUserListViewModel.shared.fetchUserList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.filteredUsers = users
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = filteredUsers[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { user in
                user.name.contains(searchText) ||
                "\(user.employeeNum)".contains(searchText) ||
                user.department.contains(searchText)
            }
        }
        tableView.reloadData()
    }
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
