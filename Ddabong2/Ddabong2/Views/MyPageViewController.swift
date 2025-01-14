import UIKit
import SideMenu
import SwiftUI

class MyPageViewController: UIViewController {
    // MARK: - ViewModels
    private let userInfoViewModel = UserInfoViewModel()
    private let myPageViewModel = MyPageViewModel()

    private var sideMenu: SideMenuNavigationController?

    // MARK: - UI Components
    private let pinkBackgroundView = UIView() // 핑크 배경
    private let whiteContainerView = UIView() // 흰색 컨테이너
    private let profileImageView = UIImageView() // 프로필 이미지
    private let greetingLabel = UILabel()
    private let fortuneLabel = UILabel()
    private let levelLabel = UILabel()
    private let nextLevelLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let progressPercentageLabel = UILabel()

    // 경험치 현황 UI
    private let experienceSectionView = UIView() // 경험치 섹션 배경
    private let recentExpLabel = UILabel()
    private let recentExpSubLabel = UILabel()
    private let recentExpTimeLabel = UILabel()
    private let recentExpPointsLabel = UILabel()
    private let thisYearExpLabel = UILabel()
    private let thisYearProgressBar = UIProgressView(progressViewStyle: .default)
    private let lastYearExpLabel = UILabel()
    private let lastYearProgressBar = UIProgressView(progressViewStyle: .default)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTitle()
        setupUI()
        setupSideMenu()
        bindViewModels()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Navigation Bar 설정
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear

        // 사용자 정보 및 UI 업데이트
        userInfoViewModel.fetchUserInfo()
        userInfoViewModel.onUserInfoFetchSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.updateProfileImage()
            }
        }
    }

    // 프로필 업데이트
    private func updateProfileImage() {
        if let avartaId = userInfoViewModel.userInfo?.avartaId,
           let profileImage = UIImage.profileImage(for: avartaId) {
            profileImageView.image = profileImage
        } else {
            profileImageView.image = UIImage(named: "defaultAvatar") // 기본 이미지
        }
    }

    // MARK: - UI Setup
    private func setupUI() {
        navigationItem.title = "마이페이지"
        setupCustomProgressBar()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "drawer")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(openSideMenu)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "alert")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem?.tintColor = .black

        pinkBackgroundView.backgroundColor = UIColor(red: 1.0, green: 0.956, blue: 0.956, alpha: 1.0) // #FFF4F4
        pinkBackgroundView.layer.cornerRadius = 12
        view.addSubview(pinkBackgroundView)

        whiteContainerView.backgroundColor = .white
        whiteContainerView.layer.cornerRadius = 12
        whiteContainerView.layer.shadowColor = UIColor.black.cgColor
        whiteContainerView.layer.shadowOpacity = 0.1
        whiteContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        whiteContainerView.layer.shadowRadius = 4
        pinkBackgroundView.addSubview(whiteContainerView)

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        whiteContainerView.addSubview(profileImageView)

        greetingLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        greetingLabel.textAlignment = .right
        whiteContainerView.addSubview(greetingLabel)

        fortuneLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        fortuneLabel.textAlignment = .right
        fortuneLabel.numberOfLines = 0
        whiteContainerView.addSubview(fortuneLabel)

        levelLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        levelLabel.textAlignment = .left
        whiteContainerView.addSubview(levelLabel)

        nextLevelLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nextLevelLabel.textAlignment = .right
        whiteContainerView.addSubview(nextLevelLabel)

        progressBar.trackTintColor = UIColor.systemGray5
        progressBar.progressTintColor = UIColor.systemOrange
        whiteContainerView.addSubview(progressBar)
        progressPercentageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        progressPercentageLabel.textAlignment = .center
        progressPercentageLabel.textColor = .white
        whiteContainerView.addSubview(progressPercentageLabel)

        experienceSectionView.backgroundColor = .white
        experienceSectionView.layer.cornerRadius = 12
        experienceSectionView.layer.shadowColor = UIColor.black.cgColor
        experienceSectionView.layer.shadowOpacity = 0.1
        experienceSectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        experienceSectionView.layer.shadowRadius = 4
        view.addSubview(experienceSectionView)

        recentExpLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        experienceSectionView.addSubview(recentExpLabel)

        recentExpSubLabel.font = UIFont.systemFont(ofSize: 14)
        experienceSectionView.addSubview(recentExpSubLabel)

        recentExpTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        recentExpTimeLabel.textColor = .systemGray
        experienceSectionView.addSubview(recentExpTimeLabel)

        recentExpPointsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        recentExpPointsLabel.textColor = .systemRed
        experienceSectionView.addSubview(recentExpPointsLabel)

        thisYearExpLabel.font = UIFont.systemFont(ofSize: 14)
        experienceSectionView.addSubview(thisYearExpLabel)

        thisYearProgressBar.progressTintColor = UIColor.systemOrange
        experienceSectionView.addSubview(thisYearProgressBar)

        lastYearExpLabel.font = UIFont.systemFont(ofSize: 14)
        experienceSectionView.addSubview(lastYearExpLabel)

        lastYearProgressBar.progressTintColor = UIColor.systemBlue
        experienceSectionView.addSubview(lastYearProgressBar)

        setConstraints()
    }

    private func setConstraints() {
        pinkBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        whiteContainerView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        fortuneLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        nextLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressPercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        experienceSectionView.translatesAutoresizingMaskIntoConstraints = false
        recentExpLabel.translatesAutoresizingMaskIntoConstraints = false
        recentExpSubLabel.translatesAutoresizingMaskIntoConstraints = false
        recentExpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        recentExpPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        thisYearExpLabel.translatesAutoresizingMaskIntoConstraints = false
        thisYearProgressBar.translatesAutoresizingMaskIntoConstraints = false
        lastYearExpLabel.translatesAutoresizingMaskIntoConstraints = false
        lastYearProgressBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pinkBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pinkBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pinkBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pinkBackgroundView.heightAnchor.constraint(equalToConstant: 230),

            whiteContainerView.topAnchor.constraint(equalTo: pinkBackgroundView.topAnchor, constant: 16),
            whiteContainerView.leadingAnchor.constraint(equalTo: pinkBackgroundView.leadingAnchor, constant: 16),
            whiteContainerView.trailingAnchor.constraint(equalTo: pinkBackgroundView.trailingAnchor, constant: -16),
            whiteContainerView.bottomAnchor.constraint(equalTo: pinkBackgroundView.bottomAnchor, constant: -16),

            profileImageView.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            greetingLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            greetingLabel.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -16),

            fortuneLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
            fortuneLabel.leadingAnchor.constraint(equalTo: greetingLabel.leadingAnchor),
            fortuneLabel.trailingAnchor.constraint(equalTo: greetingLabel.trailingAnchor),

            levelLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            levelLabel.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 16),

            nextLevelLabel.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            nextLevelLabel.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -16),

            progressBar.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 16),
            progressBar.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 8),

            progressPercentageLabel.centerXAnchor.constraint(equalTo: progressBar.centerXAnchor),
            progressPercentageLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),

            experienceSectionView.topAnchor.constraint(equalTo: pinkBackgroundView.bottomAnchor, constant: 16),
            experienceSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            experienceSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            experienceSectionView.heightAnchor.constraint(equalToConstant: 200),

            recentExpLabel.topAnchor.constraint(equalTo: experienceSectionView.topAnchor, constant: 16),
            recentExpLabel.leadingAnchor.constraint(equalTo: experienceSectionView.leadingAnchor, constant: 16),

            recentExpSubLabel.topAnchor.constraint(equalTo: recentExpLabel.bottomAnchor, constant: 8),
            recentExpSubLabel.leadingAnchor.constraint(equalTo: recentExpLabel.leadingAnchor),

            recentExpTimeLabel.trailingAnchor.constraint(equalTo: experienceSectionView.trailingAnchor, constant: -16),
            recentExpTimeLabel.topAnchor.constraint(equalTo: experienceSectionView.topAnchor, constant: 16),

            recentExpPointsLabel.trailingAnchor.constraint(equalTo: recentExpTimeLabel.trailingAnchor),
            recentExpPointsLabel.topAnchor.constraint(equalTo: recentExpTimeLabel.bottomAnchor, constant: 8),

            thisYearExpLabel.topAnchor.constraint(equalTo: recentExpSubLabel.bottomAnchor, constant: 16),
            thisYearExpLabel.leadingAnchor.constraint(equalTo: recentExpLabel.leadingAnchor),

            thisYearProgressBar.topAnchor.constraint(equalTo: thisYearExpLabel.bottomAnchor, constant: 8),
            thisYearProgressBar.leadingAnchor.constraint(equalTo: thisYearExpLabel.leadingAnchor),
            thisYearProgressBar.trailingAnchor.constraint(equalTo: experienceSectionView.trailingAnchor, constant: -16),
            thisYearProgressBar.heightAnchor.constraint(equalToConstant: 8),

            lastYearExpLabel.topAnchor.constraint(equalTo: thisYearProgressBar.bottomAnchor, constant: 16),
            lastYearExpLabel.leadingAnchor.constraint(equalTo: thisYearExpLabel.leadingAnchor),

            lastYearProgressBar.topAnchor.constraint(equalTo: lastYearExpLabel.bottomAnchor, constant: 8),
            lastYearProgressBar.leadingAnchor.constraint(equalTo: lastYearExpLabel.leadingAnchor),
            lastYearProgressBar.trailingAnchor.constraint(equalTo: experienceSectionView.trailingAnchor, constant: -16),
            lastYearProgressBar.heightAnchor.constraint(equalToConstant: 8)
        ])
    }

    private func setupCustomProgressBar() {
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        if let sublayers = progressBar.layer.sublayers, sublayers.count > 1 {
            sublayers[1].cornerRadius = 10
            sublayers[1].masksToBounds = true
        }
        progressBar.progressTintColor = UIColor(hex: "#FF6C4A")
        progressBar.trackTintColor = UIColor(hex: "#FFB4A3")
        progressPercentageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        progressPercentageLabel.textAlignment = .center
        progressPercentageLabel.textColor = .white
    }

    private func setupCustomTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "마이페이지"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = UIColor.black
        navigationItem.titleView = titleLabel
    }

    private func setupSideMenu() {
        let menuViewController = MenuViewController()
        sideMenu = SideMenuNavigationController(rootViewController: menuViewController)
        sideMenu?.leftSide = true
        sideMenu?.menuWidth = 300
        sideMenu?.presentationStyle = .menuSlideIn
    }

    // MARK: - ViewModel Binding
    private func bindViewModels() {
        myPageViewModel.onMyPageFetchSuccess = { [weak self] in
            guard let self = self, let data = self.myPageViewModel.myPageData else { return }
            DispatchQueue.main.async {
                self.updateUI(with: data)
            }
        }
        myPageViewModel.onMyPageFetchFailure = { errorMessage in
            print("Error fetching MyPage data: \(errorMessage)")
        }
    }

    private func fetchData() {
        userInfoViewModel.fetchUserInfo()
        myPageViewModel.fetchMyPageData()
    }

    private func updateUI(with data: MyPageResponseDto) {
        greetingLabel.text = "\(userInfoViewModel.userInfo?.name ?? "")님, 안녕하세요!"
        fortuneLabel.text = "\(data.fortune.date) 오늘의 운세\n\(data.fortune.contents)"

        levelLabel.text = "\(data.levelRate.currentLevel) \(data.levelRate.currentExp)"
        nextLevelLabel.text = "다음 레벨까지: \(data.levelRate.leftExp)"

        let progressValue = Float(data.levelRate.percent) / 100.0
        progressBar.progress = progressValue
        progressPercentageLabel.text = "\(data.levelRate.percent)%"

        thisYearExpLabel.text = "올해 획득한 경험치 \(data.thisYearExp.expAmount)"
        thisYearProgressBar.progress = Float(data.thisYearExp.percent) / 100.0

        lastYearExpLabel.text = "작년까지 획득한 경험치 \(data.lastYearExp.expAmount)"
        lastYearProgressBar.progress = Float(data.lastYearExp.percent) / 100.0

        recentExpLabel.text = "최근 획득 경험치"
        recentExpSubLabel.text = data.recentExp.name
        recentExpTimeLabel.text = formatDate(data.recentExp.completedAt)
        recentExpPointsLabel.text = "\(data.recentExp.expAmount) D"
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return "" }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return outputFormatter.string(from: date)
    }

    @objc private func openSideMenu() {
        guard let sideMenu = sideMenu else { return }
        present(sideMenu, animated: true, completion: nil)
    }
}
