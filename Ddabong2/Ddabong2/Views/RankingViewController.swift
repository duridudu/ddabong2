import UIKit

class RankingViewController: UIViewController, UITableViewDataSource {

    private let viewModel = RankingViewModel()

    // 헤더 컨테이너
    private let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    // 드로어 아이콘
    private let hamburgerMenu: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "drawer"), for: .normal) // SF Symbol
        button.tintColor = .black
        return button
    }()

    // 헤더 타이틀
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팀 랭킹"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    // 알림 아이콘
    private let alertIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "alert"), for: .normal) // SF Symbol
        button.tintColor = .black
        return button
    }()
   
    private func updateTimeLabel() {
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Seoul")!

        // 이번 주 일요일 자정 계산
        var nextSunday = calendar.date(bySetting: .hour, value: 0, of: currentDate)!
        nextSunday = calendar.date(bySetting: .minute, value: 0, of: nextSunday)!
        nextSunday = calendar.date(bySetting: .second, value: 0, of: nextSunday)!
        let weekday = calendar.component(.weekday, from: currentDate)

        // 현재 요일 기준으로 다음 일요일로 이동
        let daysToAdd = (7 - weekday) % 7
        nextSunday = calendar.date(byAdding: .day, value: daysToAdd, to: nextSunday)!

        let difference = nextSunday.timeIntervalSince(currentDate)
        guard difference > 0 else {
            timeLabel.text = "랭킹 마감 완료"
            return
        }

        let days = Int(difference) / (24 * 3600)
        let hours = (Int(difference) % (24 * 3600)) / 3600
        let minutes = (Int(difference) % 3600) / 60
        let seconds = Int(difference) % 60

        // 라벨 업데이트
        DispatchQueue.main.async {
            self.timeLabel.text = "\(days)일 \(hours)시간 \(minutes)분 \(seconds)초"
        }
    }
    // 상태 표시줄 배경 뷰
       private let statusBarBackgroundView: UIView = {
           let view = UIView()
           view.backgroundColor = .white // 상태 표시줄 배경색을 흰색으로 설정
           return view
       }()

    // 시간 컨테이너
    private let timeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // 아래쪽 모서리만 라운드 처리
        return view
    }()


    // 시간 설명 라벨
    private let timeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 주 랭킹 마감까지"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    // 남은 시간 라벨
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(red: 1.0, green: 0.36, blue: 0.21, alpha: 1.0) // FF5B35
        label.textAlignment = .center
        label.text = "계산 중..." // 초기 값
        return label
    }()
    
    
    //우리팀은...
    
    private let teamRankingContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white // 배경색을 흰색으로 설정
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()

    private let rankingIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rankstar") // 아이콘 이름 설정 (이미지 준비 필요)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let teamRankingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.text = nil // 초기값 설정 없음
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let rankingDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 1.0, green: 0.36, blue: 0.21, alpha: 1.0) // FF5B35
        label.text = nil // 초기값 설정 없음
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    
    private func getCurrentMonthAndWeek() -> String {
        let calendar = Calendar.current
        let currentDate = Date()

        // 월 가져오기
        let month = calendar.component(.month, from: currentDate)

        // 해당 월의 몇 번째 주인지 계산
        let weekOfMonth = calendar.component(.weekOfMonth, from: currentDate)

        return "\(month)월 \(weekOfMonth)주차 랭킹"
    }

    
    //바텀시트
    private let bottomSheet: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        return view
    }()

    private let dragHandle: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        return view
    }()

    private let bottomSheetTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let tableView = UITableView()

    private var bottomSheetHeightConstraint: NSLayoutConstraint!

    // 고정 가능한 높이
    private let collapsedHeight: CGFloat = 120
    private let midHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    private let expandedHeight: CGFloat = UIScreen.main.bounds.height * 0.8

    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경색을 흰색으로 설정
        view.backgroundColor = .white
        setupStatusBarBackground() // 상태 표시줄 배경 설정
        setupViews()
        setupGestures()
        setDefaultPosition()
        setupTableView()
        bindViewModel()
        viewModel.fetchRankings()
        // 타이머 시작
        startTimer()
        setupTeamRankingContainer()
        // Safe Area 밖으로 뷰가 확장되지 않도록 설정
        edgesForExtendedLayout = []
        bottomSheetTitleLabel.text = getCurrentMonthAndWeek()
        
    }
    // 상태 표시줄 텍스트를 검정색으로 설정
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .darkContent // 검정색 텍스트
       }

   
    private func setupStatusBarBackground() {
            // 상태 표시줄 배경 뷰 추가
            view.addSubview(statusBarBackgroundView)
            statusBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                statusBarBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                statusBarBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                statusBarBackgroundView.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height)
            ])
        }

    // 이 메서드를 viewDidLoad에서 호출
    private func setupTeamRankingContainer() {
        view.addSubview(teamRankingContainer)
        teamRankingContainer.addSubview(rankingIcon)
        teamRankingContainer.addSubview(teamRankingLabel)
        teamRankingContainer.addSubview(rankingDetailLabel)
        
        teamRankingContainer.translatesAutoresizingMaskIntoConstraints = false
        rankingIcon.translatesAutoresizingMaskIntoConstraints = false
        teamRankingLabel.translatesAutoresizingMaskIntoConstraints = false
        rankingDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            teamRankingContainer.topAnchor.constraint(equalTo: timeContainer.bottomAnchor, constant: 16), // 기존 timeContainer 아래 배치
            teamRankingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            teamRankingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            teamRankingContainer.heightAnchor.constraint(equalToConstant: 80),
            
            rankingIcon.leadingAnchor.constraint(equalTo: teamRankingContainer.leadingAnchor, constant: 16),
            rankingIcon.centerYAnchor.constraint(equalTo: teamRankingContainer.centerYAnchor),
            rankingIcon.widthAnchor.constraint(equalToConstant: 40),
            rankingIcon.heightAnchor.constraint(equalToConstant: 40),
            
            teamRankingLabel.leadingAnchor.constraint(equalTo: rankingIcon.trailingAnchor, constant: 16),
            teamRankingLabel.trailingAnchor.constraint(equalTo: teamRankingContainer.trailingAnchor, constant: -16),
            teamRankingLabel.topAnchor.constraint(equalTo: teamRankingContainer.topAnchor, constant: 16),
            
            rankingDetailLabel.leadingAnchor.constraint(equalTo: teamRankingLabel.leadingAnchor),
            rankingDetailLabel.trailingAnchor.constraint(equalTo: teamRankingLabel.trailingAnchor),
            rankingDetailLabel.topAnchor.constraint(equalTo: teamRankingLabel.bottomAnchor, constant: 4)
        ])
    }

    
    private func setupViews() {
    
        view.backgroundColor = UIColor(red: 1.0, green: 0.937, blue: 0.929, alpha: 1.0)
        
        // 헤더 레이아웃
        view.addSubview(headerContainer)
        headerContainer.addSubview(hamburgerMenu)
        headerContainer.addSubview(headerTitleLabel)
        headerContainer.addSubview(alertIcon)
        
        
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        hamburgerMenu.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertIcon.translatesAutoresizingMaskIntoConstraints = false
        // 헤더의 배경색을 흰색으로 변경
        headerContainer.backgroundColor = .white  // 변경된 부분
        
        
        NSLayoutConstraint.activate([
            
            headerContainer.topAnchor.constraint(equalTo: view.topAnchor), // 상태바 포함
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 110),

            hamburgerMenu.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            hamburgerMenu.centerYAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -25),
            hamburgerMenu.widthAnchor.constraint(equalToConstant: 24),
            hamburgerMenu.heightAnchor.constraint(equalToConstant: 24),

            headerTitleLabel.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -25),

            alertIcon.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            alertIcon.centerYAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -25),
            alertIcon.widthAnchor.constraint(equalToConstant: 24),
            alertIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // 시간 컨테이너
        view.addSubview(timeContainer)
        timeContainer.addSubview(timeDescriptionLabel)
        timeContainer.addSubview(timeLabel)
        timeContainer.translatesAutoresizingMaskIntoConstraints = false
        timeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 시간 컨테이너의 배경색을 부드럽게 이어지도록 설정 (그라데이션 효과)
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = timeContainer.bounds
            gradientLayer.colors = [UIColor.white.cgColor, UIColor(red: 1.0, green: 0.937, blue: 0.929, alpha: 1.0).cgColor] // 부드러운 색상 전환
            timeContainer.layer.insertSublayer(gradientLayer, at: 0)

        // 시간 컨테이너
        NSLayoutConstraint.activate([
            timeContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0),
            timeContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timeContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timeContainer.heightAnchor.constraint(equalToConstant: 100),

            timeDescriptionLabel.topAnchor.constraint(equalTo: timeContainer.topAnchor, constant: 16),
            timeDescriptionLabel.centerXAnchor.constraint(equalTo: timeContainer.centerXAnchor),

            timeLabel.topAnchor.constraint(equalTo: timeDescriptionLabel.bottomAnchor, constant: 8),
            timeLabel.centerXAnchor.constraint(equalTo: timeContainer.centerXAnchor)
        ])

        // Bottom Sheet
        view.addSubview(bottomSheet)
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetHeightConstraint = bottomSheet.heightAnchor.constraint(equalToConstant: midHeight)
        NSLayoutConstraint.activate([
            bottomSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheet.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetHeightConstraint
        ])

        // Drag Handle
        bottomSheet.addSubview(dragHandle)
        dragHandle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dragHandle.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 8),
            dragHandle.centerXAnchor.constraint(equalTo: bottomSheet.centerXAnchor),
            dragHandle.widthAnchor.constraint(equalToConstant: 40),
            dragHandle.heightAnchor.constraint(equalToConstant: 5)
        ])

        // Title Label
        bottomSheet.addSubview(bottomSheetTitleLabel)
        bottomSheetTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSheetTitleLabel.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: 16),
            bottomSheetTitleLabel.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor, constant: 16),
            bottomSheetTitleLabel.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -16)
        ])
    }

    private func startTimer() {
        updateTimeLabel() // 초기 값 설정
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimeLabel()
        }
    }
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        bottomSheet.addGestureRecognizer(panGesture)
    }

    private func setDefaultPosition() {
        bottomSheetHeightConstraint.constant = midHeight
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(RankingTableViewCell.self, forCellReuseIdentifier: "RankingCell")
        bottomSheet.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bottomSheetTitleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomSheet.bottomAnchor, constant: -16)
        ])
    }

    private func bindViewModel() {
        viewModel.onRankingsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .changed:
            let newHeight = bottomSheetHeightConstraint.constant - translation.y
            bottomSheetHeightConstraint.constant = max(collapsedHeight, min(expandedHeight, newHeight))
            gesture.setTranslation(.zero, in: view)

            // 바텀시트를 최상위 레이어로 유지
            view.bringSubviewToFront(bottomSheet)

        case .ended:
            let targetHeight: CGFloat
            let currentHeight = bottomSheetHeightConstraint.constant
            if abs(currentHeight - collapsedHeight) < abs(currentHeight - midHeight) {
                targetHeight = collapsedHeight
            } else if abs(currentHeight - midHeight) < abs(currentHeight - expandedHeight) {
                targetHeight = midHeight
            } else {
                targetHeight = expandedHeight
            }

            bottomSheetHeightConstraint.constant = targetHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }

            // 애니메이션 종료 후에도 바텀시트를 최상위로 유지
            view.bringSubviewToFront(bottomSheet)

        default:
            break
        }
    }


    // teamRankingContainer의 가시성 업데이트
    private func updateTeamRankingVisibility() {
        // bottomSheet가 midHeight 이상 올라가면 숨김 처리
        let isHidden = bottomSheetHeightConstraint.constant >= midHeight
        teamRankingContainer.isHidden = isHidden
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRankings().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! RankingTableViewCell
        let rank = viewModel.getRankings()[indexPath.row]
        let departmentName = mapDepartmentIdToName(rank.departmentId)
        cell.configure(rank: rank.rank, department: departmentName, score: rank.expAvg)
        return cell
    }

    private func mapDepartmentIdToName(_ departmentId: Int) -> String {
        let departmentNames = [
            1: "음성 1센터",
            2: "음성 2센터",
            3: "용인백암센터",
            4: "남양주센터",
            5: "파주센터",
            6: "사업기획팀",
            7: "그로스팀",
            8: "CX팀"
        ]
        return departmentNames[departmentId] ?? "Unknown Department"
    }
    
}
