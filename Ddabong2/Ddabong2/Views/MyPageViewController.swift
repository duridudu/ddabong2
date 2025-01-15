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
    private let experienceContainerView = UIView() // 경험치 섹션 컨테이너
    private let experienceTitleLabel = UILabel()
    private let recentExpLabel = UILabel()
    private let viewAllButton = UIButton(type: .system)
    private let thisYearExpLabel = UILabel()
    private let thisYearProgressBar = UIProgressView(progressViewStyle: .default)
    private let lastYearExpLabel = UILabel()
    private let lastYearProgressBar = UIProgressView(progressViewStyle: .default)
    private let thisYearProgressPercentageLabel = UILabel()
    private let lastYearProgressPercentageLabel = UILabel()

    override func viewDidLoad() {
        view.backgroundColor = UIColor.white // 배경색을 흰색으로 설정
        super.viewDidLoad()
        setupCustomHeader() // 헤더 설정
        setupUI()
        setupSideMenu()
        bindViewModels()
        fetchData()
    }

    
    private func updateProfileImage() {
        if let avartaId = userInfoViewModel.userInfo?.avartaId,
           let profileImage = UIImage.profileImage(for: avartaId) {
            profileImageView.image = profileImage
        } else {
            print("Image not found or avartaId is nil")
            profileImageView.image = UIImage(named: "avatar1") // 기본 이미지
        }
    }

    // MARK: - UI Setup
       private func setupCustomHeader() {
           let headerContainer = UIView()
           headerContainer.backgroundColor = .white
           view.addSubview(headerContainer)
           headerContainer.translatesAutoresizingMaskIntoConstraints = false

           let hamburgerMenu = UIButton()
           hamburgerMenu.setImage(UIImage(named: "drawer"), for: .normal)
           hamburgerMenu.tintColor = .black
           hamburgerMenu.addTarget(self, action: #selector(openSideMenu), for: .touchUpInside)
           headerContainer.addSubview(hamburgerMenu)
           hamburgerMenu.translatesAutoresizingMaskIntoConstraints = false

           let headerTitleLabel = UILabel()
           headerTitleLabel.text = "마이페이지"
           headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
           headerTitleLabel.textColor = .black
           headerTitleLabel.textAlignment = .center
           headerContainer.addSubview(headerTitleLabel)
           headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false

           let alertIcon = UIButton()
           alertIcon.setImage(UIImage(named: "alert"), for: .normal)
           alertIcon.tintColor = .black
           headerContainer.addSubview(alertIcon)
           alertIcon.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               headerContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 50), // Safe Area 무시하고 5 아래로 이동
               headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               headerContainer.heightAnchor.constraint(equalToConstant: 50),

               hamburgerMenu.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
               hamburgerMenu.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
               hamburgerMenu.widthAnchor.constraint(equalToConstant: 24),
               hamburgerMenu.heightAnchor.constraint(equalToConstant: 24),

               headerTitleLabel.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
               headerTitleLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),

               alertIcon.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
               alertIcon.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
               alertIcon.widthAnchor.constraint(equalToConstant: 24),
               alertIcon.heightAnchor.constraint(equalToConstant: 24)
           ])
       }
    
    // MARK: - UI Setup
    private func setupUI() {

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
        
        progressBar.progressTintColor = UIColor(hex: "#FF6C4A")
        progressBar.trackTintColor = UIColor(hex: "#FFB4A3")
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true

        
        whiteContainerView.addSubview(progressBar)
        progressPercentageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        progressPercentageLabel.textAlignment = .center
        progressPercentageLabel.textColor = .white
        whiteContainerView.addSubview(progressPercentageLabel)

        // 경험치 컨테이너 추가
        experienceContainerView.backgroundColor = .clear
        view.addSubview(experienceContainerView)

        experienceTitleLabel.text = "경험치 현황"
        experienceTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        experienceTitleLabel.textAlignment = .left
        experienceContainerView.addSubview(experienceTitleLabel)

        recentExpLabel.text = "최근 획득 경험치"
        recentExpLabel.font = UIFont.boldSystemFont(ofSize: 15)
        recentExpLabel.textColor = UIColor(hex: "#494949") // 텍스트 색상 변경
        recentExpLabel.textAlignment = .left
        experienceContainerView.addSubview(recentExpLabel)
        
        

        viewAllButton.setTitle("전체보기 >", for: .normal)
        viewAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        experienceContainerView.addSubview(viewAllButton)
        viewAllButton.setTitleColor(UIColor(hex: "#757575"), for: .normal)


        thisYearExpLabel.text = "올해 획득한 경험치"
        thisYearExpLabel.font = UIFont.systemFont(ofSize: 14)
        thisYearExpLabel.textColor = UIColor(hex: "#777777")
        

        experienceContainerView.addSubview(thisYearExpLabel)

        thisYearProgressBar.progressTintColor = UIColor(hex: "#FF6C4A")
        thisYearProgressBar.trackTintColor = UIColor(hex: "#FFB4A3")
        experienceContainerView.addSubview(thisYearProgressBar)



        lastYearExpLabel.text = "작년까지 획득한 경험치"
        lastYearExpLabel.font = UIFont.systemFont(ofSize: 14)
        experienceContainerView.addSubview(lastYearExpLabel)
        lastYearExpLabel.textColor = UIColor(hex: "#777777")

        lastYearProgressBar.progressTintColor = UIColor(hex: "#FF6C4A")
        lastYearProgressBar.trackTintColor = UIColor(hex: "#FFB4A3")
        experienceContainerView.addSubview(lastYearProgressBar)
        
        // 올해 퍼센트 라벨
        thisYearProgressPercentageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        thisYearProgressPercentageLabel.textColor = .white
        thisYearProgressPercentageLabel.textAlignment = .center
        experienceContainerView.addSubview(thisYearProgressPercentageLabel)

        // 작년 퍼센트 라벨
        lastYearProgressPercentageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        lastYearProgressPercentageLabel.textColor = .white
        lastYearProgressPercentageLabel.textAlignment = .center
        experienceContainerView.addSubview(lastYearProgressPercentageLabel)
        thisYearProgressPercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastYearProgressPercentageLabel.translatesAutoresizingMaskIntoConstraints = false


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
        experienceContainerView.translatesAutoresizingMaskIntoConstraints = false
        experienceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recentExpLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        thisYearExpLabel.translatesAutoresizingMaskIntoConstraints = false
        thisYearProgressBar.translatesAutoresizingMaskIntoConstraints = false
        lastYearExpLabel.translatesAutoresizingMaskIntoConstraints = false
        lastYearProgressBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.deactivate(pinkBackgroundView.constraints)
        NSLayoutConstraint.deactivate(whiteContainerView.constraints)
        
        NSLayoutConstraint.activate([
            pinkBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            pinkBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pinkBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pinkBackgroundView.heightAnchor.constraint(equalToConstant: 250),
            
            whiteContainerView.topAnchor.constraint(equalTo: pinkBackgroundView.topAnchor, constant: 20), // 간격 조정
            whiteContainerView.leadingAnchor.constraint(equalTo: pinkBackgroundView.leadingAnchor, constant: 24),
            whiteContainerView.trailingAnchor.constraint(equalTo: pinkBackgroundView.trailingAnchor, constant: -24),
            whiteContainerView.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 30), // 흰색 컨테이너를 확장
            
            profileImageView.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 21),
            profileImageView.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            
            greetingLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 21),
            greetingLabel.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -16),
            
            fortuneLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 13),
            fortuneLabel.leadingAnchor.constraint(equalTo: greetingLabel.leadingAnchor),
            fortuneLabel.trailingAnchor.constraint(equalTo: greetingLabel.trailingAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: fortuneLabel.bottomAnchor, constant: 21), // 프로필 아래로 이동
            levelLabel.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 16),
            
            nextLevelLabel.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            nextLevelLabel.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -16),
            
            progressBar.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 13),
            progressBar.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 30),
            
            progressPercentageLabel.centerXAnchor.constraint(equalTo: progressBar.centerXAnchor),
            progressPercentageLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            
            experienceContainerView.topAnchor.constraint(equalTo: pinkBackgroundView.bottomAnchor, constant: 21),
            experienceContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            experienceContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            experienceTitleLabel.topAnchor.constraint(equalTo: experienceContainerView.topAnchor),
            experienceTitleLabel.leadingAnchor.constraint(equalTo: experienceContainerView.leadingAnchor),
            
            recentExpLabel.topAnchor.constraint(equalTo: experienceTitleLabel.bottomAnchor, constant: 21),
            recentExpLabel.leadingAnchor.constraint(equalTo: experienceContainerView.leadingAnchor),
            
            viewAllButton.centerYAnchor.constraint(equalTo: recentExpLabel.centerYAnchor),
            viewAllButton.trailingAnchor.constraint(equalTo: experienceContainerView.trailingAnchor),
            
            thisYearExpLabel.topAnchor.constraint(equalTo: recentExpLabel.bottomAnchor, constant: 24),
            thisYearExpLabel.leadingAnchor.constraint(equalTo: experienceContainerView.leadingAnchor),
            
            thisYearProgressBar.topAnchor.constraint(equalTo: thisYearExpLabel.bottomAnchor, constant: 13),
            thisYearProgressBar.leadingAnchor.constraint(equalTo: experienceContainerView.leadingAnchor),
            thisYearProgressBar.trailingAnchor.constraint(equalTo: experienceContainerView.trailingAnchor),
            thisYearProgressBar.heightAnchor.constraint(equalToConstant: 20),
            
            lastYearExpLabel.topAnchor.constraint(equalTo: thisYearProgressBar.bottomAnchor, constant: 21),
            lastYearExpLabel.leadingAnchor.constraint(equalTo: experienceContainerView.leadingAnchor),
            
            lastYearProgressBar.topAnchor.constraint(equalTo: lastYearExpLabel.bottomAnchor, constant: 13),
            lastYearProgressBar.leadingAnchor.constraint(equalTo: experienceContainerView.leadingAnchor),
            lastYearProgressBar.trailingAnchor.constraint(equalTo: experienceContainerView.trailingAnchor),
            lastYearProgressBar.heightAnchor.constraint(equalToConstant: 20),
            
            thisYearProgressPercentageLabel.centerXAnchor.constraint(equalTo: thisYearProgressBar.centerXAnchor),
            thisYearProgressPercentageLabel.centerYAnchor.constraint(equalTo: thisYearProgressBar.centerYAnchor),
            
            lastYearProgressPercentageLabel.centerXAnchor.constraint(equalTo: lastYearProgressBar.centerXAnchor),
            lastYearProgressPercentageLabel.centerYAnchor.constraint(equalTo: lastYearProgressBar.centerYAnchor)
        ])
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
        
        // 날짜 변환 (n월 n일 형식)
        let formattedDate = formatToMonthDay(data.fortune.date)
        let firstPart = "\(formattedDate) 오늘의 운세"
        let secondPart = "\(data.fortune.contents)"
        
        // 전체 텍스트 생성
        let fullText = "\(firstPart)\n\(secondPart)"

        // NSMutableAttributedString으로 스타일 지정
        let attributedText = NSMutableAttributedString(string: fullText)

        // 첫 번째 부분 스타일 설정 (세미볼드, 글씨 크기 15)
        if let range = fullText.range(of: firstPart) {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .semibold), range: nsRange)
        }

        // 두 번째 부분 스타일 설정 (글씨 크기 13, 색상 777777)
        if let range = fullText.range(of: secondPart) {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: nsRange)
            attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#777777"), range: nsRange)
        }

        // 설정한 스타일을 레이블에 적용
        fortuneLabel.attributedText = attributedText

        
        
        // 텍스트 분리
        let levelText = "\(data.levelRate.currentLevel)"
        let expText = "\(data.levelRate.currentExp)"

        // 공백 텍스트 생성 (크기 13)
        let spaceText = "\n"

        // 전체 텍스트 생성
        let fullText2 = "\(spaceText)\(levelText) \(expText)"

        // NSMutableAttributedString으로 스타일 지정
        let attributedText2 = NSMutableAttributedString(string: fullText2)

        // 첫 번째 부분 스타일 설정 (볼드)
        if let range = fullText2.range(of: levelText) {
            let nsRange = NSRange(range, in: fullText2)
            attributedText2.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
            attributedText2.addAttribute(.foregroundColor, value: UIColor(hex: "#FF704F"), range: nsRange)
        }

        // 공백 텍스트 스타일 설정 (크기 13)
        if let range = fullText2.range(of: spaceText) {
            let nsRange = NSRange(range, in: fullText2)
            attributedText2.addAttribute(.font, value: UIFont.systemFont(ofSize: 13), range: nsRange)
            attributedText2.addAttribute(.foregroundColor, value: UIColor.clear, range: nsRange) // 투명색으로 설정
        }

        // 두 번째 부분 스타일 설정 (세미볼드)
        if let range = fullText2.range(of: expText) {
            let nsRange = NSRange(range, in: fullText2)
            attributedText2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .semibold), range: nsRange)
            attributedText2.addAttribute(.foregroundColor, value: UIColor(hex: "#FF704F"), range: nsRange)
        }

        // 설정한 스타일을 레이블에 적용
        levelLabel.numberOfLines = 0 // 멀티라인 활성화
        levelLabel.attributedText = attributedText2


        
        
        // 텍스트 분리
        let titleText = "내년도 예상 레벨\n"
        let nextLevelText = "\(data.levelRate.nextLevel) 승급까지 "
        let leftExpText = "\(data.levelRate.leftExp)D"

        // 전체 텍스트 생성
        let fullText3 = "\(titleText)\(nextLevelText)\(leftExpText)"

        // NSMutableAttributedString으로 스타일 지정
        let attributedText3 = NSMutableAttributedString(string: fullText3)

        // 첫 번째 줄 스타일 설정 ("내년도 예상 레벨")
        if let range = fullText3.range(of: titleText) {
            let nsRange = NSRange(range, in: fullText3)
            attributedText3.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 13), range: nsRange)
            attributedText3.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "#777777"), range: nsRange)
        }

        // 두 번째 줄 스타일 설정 ("nextLevel 승급까지")
        if let range = fullText3.range(of: nextLevelText) {
            let nsRange = NSRange(range, in: fullText3)
            attributedText3.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: nsRange) // 볼드 처리
            attributedText3.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "#FF704F"), range: nsRange)
        }

        // 세 번째 줄 스타일 설정 ("leftExp D")
        if let range = fullText3.range(of: leftExpText) {
            let nsRange = NSRange(range, in: fullText3)
            attributedText3.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: nsRange) // 볼드 처리
            attributedText3.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "#FF704F"), range: nsRange)
        }

        // 설정한 스타일을 레이블에 적용
        nextLevelLabel.numberOfLines = 2
        nextLevelLabel.attributedText = attributedText3

        // 설정한 스타일을 레이블에 적용
        nextLevelLabel.numberOfLines = 2
        nextLevelLabel.attributedText = attributedText3


        let progressValue = Float(data.levelRate.percent) / 100.0
        progressBar.progress = progressValue
        progressPercentageLabel.text = "\(data.levelRate.percent)%"

        thisYearExpLabel.text = "올해 획득한 경험치 \(data.thisYearExp.expAmount)"
        thisYearProgressBar.progress = Float(data.thisYearExp.percent) / 100.0
        thisYearProgressBar.layer.cornerRadius = 5
        thisYearProgressBar.clipsToBounds = true

        lastYearExpLabel.text = "작년까지 획득한 경험치 \(data.lastYearExp.expAmount)"
        lastYearProgressBar.progress = Float(data.lastYearExp.percent) / 100.0
        lastYearProgressBar.layer.cornerRadius = 5
        lastYearProgressBar.clipsToBounds = true

        recentExpLabel.text = "최근 획득 경험치"
        thisYearProgressPercentageLabel.text = "\(data.thisYearExp.percent)%"
        lastYearProgressPercentageLabel.text = "\(data.lastYearExp.percent)%"

    }

    private func formatToMonthDay(_ isoDateString: String) -> String {
        // 입력 형식: "yyyy-MM-dd"
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ko_KR") // 한국 로케일
        inputFormatter.dateFormat = "yyyy-MM-dd" // 서버 제공 형식에 맞춤

        // 입력 문자열을 Date로 변환
        guard let date = inputFormatter.date(from: isoDateString) else {
            return "날짜 형식 오류"
        }

        // 출력 형식: "MM월 dd일"
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR") // 한국 로케일
        outputFormatter.dateFormat = "MM월 dd일" // 예: "01월 13일"

        return outputFormatter.string(from: date)
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

        // 사용자 정보 및 UI 업데이트
               userInfoViewModel.fetchUserInfo()
               userInfoViewModel.onUserInfoFetchSuccess = { [weak self] in
                   DispatchQueue.main.async {
                       self?.updateProfileImage()
                   }
               }

        
           // 레이아웃 갱신 방지
           navigationController?.navigationBar.isHidden = true
       }

    @objc private func openSideMenu() {
        guard let sideMenu = sideMenu else { return }
        present(sideMenu, animated: true, completion: nil)
    }
}
