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
        setupUI()
        setupSideMenu()
        bindViewModels()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Navigation Bar를 투명하게 설정
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }

    // MARK: - UI Setup
    private func setupUI() {
        navigationItem.title = "마이페이지"

        // 사이드 메뉴 및 알림 버튼
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

        // 핑크 배경 설정
        pinkBackgroundView.backgroundColor = UIColor(red: 1.0, green: 0.956, blue: 0.956, alpha: 1.0) // #FFF4F4
        pinkBackgroundView.layer.cornerRadius = 12
        view.addSubview(pinkBackgroundView)

        // 흰색 컨테이너 설정
        whiteContainerView.backgroundColor = .white
        whiteContainerView.layer.cornerRadius = 12
        whiteContainerView.layer.shadowColor = UIColor.black.cgColor
        whiteContainerView.layer.shadowOpacity = 0.1
        whiteContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        whiteContainerView.layer.shadowRadius = 4
        pinkBackgroundView.addSubview(whiteContainerView)

        // 프로필 이미지 설정
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 36
        profileImageView.clipsToBounds = true
        whiteContainerView.addSubview(profileImageView)

        // Greeting Label (안녕하세요)
        greetingLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        greetingLabel.textAlignment = .right
        whiteContainerView.addSubview(greetingLabel)

        // Fortune Label (운세)
        fortuneLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        fortuneLabel.textAlignment = .right
        fortuneLabel.numberOfLines = 0
        whiteContainerView.addSubview(fortuneLabel)

        // Level Label
        levelLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        levelLabel.textAlignment = .left
        whiteContainerView.addSubview(levelLabel)

        nextLevelLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nextLevelLabel.textAlignment = .right
        whiteContainerView.addSubview(nextLevelLabel)

        // Progress Bar
        progressBar.progressTintColor = UIColor.systemOrange
        progressBar.trackTintColor = UIColor.systemGray5
        whiteContainerView.addSubview(progressBar)

        progressPercentageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        progressPercentageLabel.textAlignment = .center
        progressPercentageLabel.textColor = .white
        whiteContainerView.addSubview(progressPercentageLabel)

        // 경험치 섹션
        experienceSectionView.backgroundColor = .white
        experienceSectionView.layer.cornerRadius = 12
        experienceSectionView.layer.shadowColor = UIColor.black.cgColor
        experienceSectionView.layer.shadowOpacity = 0.1
        experienceSectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        experienceSectionView.layer.shadowRadius = 4
        view.addSubview(experienceSectionView)

        
        //경험치 현황
        // 최근 경험치
        recentExpLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        recentExpLabel.text = "최근 획득 경험치" // 임의 데이터
        experienceSectionView.addSubview(recentExpLabel)

        recentExpSubLabel.font = UIFont.systemFont(ofSize: 14)
        recentExpSubLabel.text = "생산성 MAX 달성" // 임의 데이터
        experienceSectionView.addSubview(recentExpSubLabel)

        recentExpTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        recentExpTimeLabel.textColor = .systemGray
        recentExpTimeLabel.text = "5분 전" // 임의 데이터
        experienceSectionView.addSubview(recentExpTimeLabel)

        recentExpPointsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        recentExpPointsLabel.textColor = .systemRed
        recentExpPointsLabel.text = "80 D" // 임의 데이터
        experienceSectionView.addSubview(recentExpPointsLabel)

        // 올해 경험치
        thisYearExpLabel.font = UIFont.systemFont(ofSize: 14)
        thisYearExpLabel.text = "올해 획득한 경험치 7,500" // 임의 데이터
        experienceSectionView.addSubview(thisYearExpLabel)

        thisYearProgressBar.progressTintColor = UIColor.systemOrange
        experienceSectionView.addSubview(thisYearProgressBar)

        // 작년 경험치
        lastYearExpLabel.font = UIFont.systemFont(ofSize: 14)
        lastYearExpLabel.text = "작년까지 획득한 경험치 3,000" // 임의 데이터
        experienceSectionView.addSubview(lastYearExpLabel)

        lastYearProgressBar.progressTintColor = UIColor.systemBlue
        experienceSectionView.addSubview(lastYearProgressBar)

        // Constraints
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
            profileImageView.widthAnchor.constraint(equalToConstant: 72),
            profileImageView.heightAnchor.constraint(equalToConstant: 72),

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
    }

    private func fetchData() {
        userInfoViewModel.fetchUserInfo()
        myPageViewModel.fetchMyPageData()
    }

    private func updateUI(with data: MyPageResponseDto) {
        greetingLabel.text = "\(userInfoViewModel.userInfo?.name ?? "")님, 안녕하세요!"
        fortuneLabel.text = "\(data.fortune.date) 운세\n\(data.fortune.contents)"
        levelLabel.text = "\(data.levelRate.currentLevel) \(data.levelRate.currentExp)"
        nextLevelLabel.text = "다음 레벨까지: \(data.levelRate.leftExp)"
        progressBar.progress = Float(data.levelRate.percent) / 100.0
        progressPercentageLabel.text = "\(data.levelRate.percent)%"
        profileImageView.image = UIImage(named: "profile") // 프로필 이미지 설정

        thisYearProgressBar.progress = Float(data.thisYearExp.percent) / 100.0
        lastYearProgressBar.progress = Float(data.lastYearExp.percent) / 100.0
    }

    @objc private func openSideMenu() {
        guard let sideMenu = sideMenu else { return }
        present(sideMenu, animated: true, completion: nil)
    }
}
