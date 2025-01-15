import UIKit

class AdminMenuViewController: UIViewController {

    // MARK: - UI Components
    private let profileBackgroundView = UIView()
    private let nameLabel = UILabel()
    private let idLabel = UILabel()
    private let menuTableView = UITableView()
    private let menuItems = ["메인 화면으로", "로그아웃"]
    private let menuIcons = ["drawer_home", "drawer_logout"]

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
        setupConstraints()
        setupAdminInfo()
    }

    // MARK: - Setup Admin Info
    private func setupAdminInfo() {
        // 어드민 이름과 ID 표시
        nameLabel.text = "관리자"
        idLabel.text = "admin"
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Profile Background View with Custom Image
        setupBackgroundImage(for: profileBackgroundView)
        view.addSubview(profileBackgroundView)

        // Name Label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = UIColor.black
        profileBackgroundView.addSubview(nameLabel)

        // ID Label
        idLabel.font = UIFont.systemFont(ofSize: 14)
        idLabel.textColor = UIColor.gray
        profileBackgroundView.addSubview(idLabel)

        // Menu TableView
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        view.addSubview(menuTableView)
    }

    private func setupBackgroundImage(for view: UIView) {
        let backgroundImage = UIImageView(image: UIImage(named: "adminback")) // 배경 이미지 변경
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Constraints
    private func setupConstraints() {
        profileBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        menuTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Profile Background View
            profileBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // Notch 부분 제외
            profileBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileBackgroundView.heightAnchor.constraint(equalToConstant: 150),

            // Name Label
            nameLabel.topAnchor.constraint(equalTo: profileBackgroundView.topAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: profileBackgroundView.leadingAnchor, constant: 20),

            // ID Label
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: profileBackgroundView.leadingAnchor, constant: 20),

            // Menu TableView
            menuTableView.topAnchor.constraint(equalTo: profileBackgroundView.bottomAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - 로그아웃 모달 띄우기
    private func showLogoutModal() {
        let modalVC = LogoutModalViewController()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.onConfirm = {
            LogoutService.shared.logoutUser { success in
                if success {
                    // 로그아웃 성공 처리: 로그인 화면으로 이동
                    DispatchQueue.main.async {
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true, completion: nil)
                    }
                } else {
                    // 로그아웃 실패 처리
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "오류", message: "로그아웃에 실패했습니다. 다시 시도해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        present(modalVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AdminMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = .black
        cell.imageView?.image = UIImage(named: menuIcons[indexPath.row])
        cell.imageView?.tintColor = .black
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("메인 화면으로 이동")
            // AdminMainViewController로 이동 (push 방식)
            let adminMainVC = AdminMainViewController()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(adminMainVC, animated: true)
            } else {
                // NavigationController가 없으면 새로 생성
                let navController = UINavigationController(rootViewController: adminMainVC)
                navController.modalPresentationStyle = .fullScreen
                present(navController, animated: true, completion: nil)
            }
        case 1:
            print("로그아웃 선택됨")
            showLogoutModal()
        default:
            break
        }
    }
}
