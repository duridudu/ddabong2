// 마이페이지
// 일반 유저 개인정보 조회 가능
// (유저, 오늘의 운세, 경험치)는 마이페이지 API에서 받아옴
// JH

import UIKit
import SideMenu

class MyPageViewController: UIViewController {

    // MARK: - ViewModel
    private let userInfoViewModel = UserInfoViewModel()

    // MARK: - SideMenu Navigation Controller
    private var sideMenu: SideMenuNavigationController?

    // MARK: - UI Components
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let drawerButton = UIButton(type: .system)
    private let alertButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // Greeting Card Components
    private let greetingLabel = UILabel()
    private let dateLabel = UILabel()
    private let progressLabel = UILabel()
    private let progressSubtitleLabel = UILabel()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white // 배경색을 흰색으로 설정
        setupUI()
        setupSideMenu()
        setupBindings()
        fetchUserInfo()
    }

    // MARK: - Bindings
    private func setupBindings() {
        userInfoViewModel.onUserInfoFetchSuccess = { [weak self] in
            DispatchQueue.main.async {
                guard let user = self?.userInfoViewModel.userInfo else { return }
                self?.updateUI(with: user)
            }
        }

        userInfoViewModel.onUserInfoFetchFailure = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }

    // MARK: - Fetch User Info
    private func fetchUserInfo() {
        userInfoViewModel.fetchUserInfo()
    }

    // MARK: - Update UI
    private func updateUI(with user: User) {
        greetingLabel.text = "\(user.name)님, 안녕하세요!"
        dateLabel.text = "01월 08일 오늘의 운세\n혼들리지 말고 소신껏!"
        progressLabel.text = "\(user.level) \(user.employeeNum)"
        progressSubtitleLabel.text = "F2-I 승급까지 -3000"
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupHeaderView()
        setupScrollView()
        setupGreetingCard()
    }

    private func setupHeaderView() {
        // Header View
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Drawer Button
        drawerButton.setImage(UIImage(named: "drawer"), for: .normal)
        drawerButton.tintColor = .black
        drawerButton.addTarget(self, action: #selector(drawerButtonTapped), for: .touchUpInside)
        headerView.addSubview(drawerButton)
        drawerButton.translatesAutoresizingMaskIntoConstraints = false

        // Title Label
        titleLabel.text = "마이페이지"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Alert Button
        alertButton.setImage(UIImage(named: "alert"), for: .normal)
        alertButton.tintColor = .black
        alertButton.addTarget(self, action: #selector(alertButtonTapped), for: .touchUpInside)
        headerView.addSubview(alertButton)
        alertButton.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),

            drawerButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            drawerButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            drawerButton.widthAnchor.constraint(equalToConstant: 24),
            drawerButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            alertButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            alertButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            alertButton.widthAnchor.constraint(equalToConstant: 24),
            alertButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupGreetingCard() {
        let cardBackgroundView = UIView()
        cardBackgroundView.backgroundColor = UIColor(red: 1.0, green: 0.956, blue: 0.956, alpha: 1.0) // FFF4F4
        contentView.addSubview(cardBackgroundView)
        cardBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        let greetingCardView = UIView()
        greetingCardView.layer.cornerRadius = 12
        greetingCardView.backgroundColor = .white
        greetingCardView.layer.shadowColor = UIColor.black.cgColor
        greetingCardView.layer.shadowOpacity = 0.1
        greetingCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        greetingCardView.layer.shadowRadius = 4
        cardBackgroundView.addSubview(greetingCardView)
        greetingCardView.translatesAutoresizingMaskIntoConstraints = false

        // Greeting Label
        greetingCardView.addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false

        // Date Label
        greetingCardView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        // Progress Label
        greetingCardView.addSubview(progressLabel)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false

        // Progress Subtitle Label
        greetingCardView.addSubview(progressSubtitleLabel)
        progressSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        NSLayoutConstraint.activate([
            cardBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardBackgroundView.heightAnchor.constraint(equalToConstant: 200),

            greetingCardView.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 16),
            greetingCardView.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 16),
            greetingCardView.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -16),
            greetingCardView.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -16),

            greetingLabel.topAnchor.constraint(equalTo: greetingCardView.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: greetingCardView.leadingAnchor, constant: 16),

            dateLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: greetingCardView.leadingAnchor, constant: 16),

            progressLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            progressLabel.leadingAnchor.constraint(equalTo: greetingCardView.leadingAnchor, constant: 16),

            progressSubtitleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            progressSubtitleLabel.trailingAnchor.constraint(equalTo: greetingCardView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Actions
    @objc private func drawerButtonTapped() {
        guard let sideMenu = sideMenu else { return }
        present(sideMenu, animated: true, completion: nil)
    }

    @objc private func alertButtonTapped() {
        print("Alert 버튼 눌림")
    }

    // MARK: - SideMenu 설정
    private func setupSideMenu() {
        let menuViewController = MenuViewController()
        sideMenu = SideMenuNavigationController(rootViewController: menuViewController)
        sideMenu?.leftSide = true
        sideMenu?.menuWidth = 300
        sideMenu?.presentationStyle = .menuSlideIn
        sideMenu?.statusBarEndAlpha = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
