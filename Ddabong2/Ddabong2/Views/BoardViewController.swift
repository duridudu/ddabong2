import UIKit
import SideMenu

class BoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private var sideMenu: SideMenuNavigationController?

    
    private let viewModel = BoardViewModel() // ViewModel
    private let tableView = UITableView() // TableView

    // 상단 배경 그라데이션
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(red: 1.0, green: 0.96, blue: 0.92, alpha: 1.0).cgColor,
            UIColor(red: 1.0, green: 0.84, blue: 0.80, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return gradientLayer
    }()
    
    private func setupGradientBackground() {
        // 그라데이션 영역의 높이를 줄임
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(red: 1.0, green: 0.96, blue: 0.92, alpha: 1.0).cgColor,
            UIColor(red: 1.0, green: 0.84, blue: 0.80, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        // 줄어든 높이를 반영
        gradientLayer.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 250)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }



    private func setupCurveWithShadow() {
        let curvePath = UIBezierPath()
        curvePath.move(to: CGPoint(x: 0, y: 300))
        curvePath.addQuadCurve(to: CGPoint(x: view.bounds.width, y: 300),
                               controlPoint: CGPoint(x: view.bounds.width / 2, y: 250))
        curvePath.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        curvePath.addLine(to: CGPoint(x: 0, y: view.bounds.height))
        curvePath.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = curvePath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.4
        shapeLayer.shadowOffset = CGSize(width: 0, height: 10)
        shapeLayer.shadowRadius = 10

        view.layer.insertSublayer(shapeLayer, at: 1)
    }
    private let notchBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // 상단 바
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "drawer"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시판"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "alert"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoAndSloganStackView: UIStackView = {
        let sloganLabel = UILabel()
        sloganLabel.text = "멈추지 않는 도전,"
        sloganLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        sloganLabel.textColor = UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 1.0)
        sloganLabel.textAlignment = .right

        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "boardlogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 45.5).isActive = true

        let stackView = UIStackView(arrangedSubviews: [sloganLabel, logoImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private let boardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근글"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .black
        return label
    }()

    private let viewAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체보기 >", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didTapViewAllButton), for: .touchUpInside)
        return button
    }()
    
    private let topBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupCurveWithShadow()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.fetchBoards(size: 6) // 최신 게시글 6개 가져오기
    }

    private func setupUI() {
        view.addSubview(topBackgroundView) // 상태바와 탑바뷰 흰색 배경 추가
        view.addSubview(topBarView)
        topBarView.addSubview(menuButton)
        topBarView.addSubview(titleLabel)
        topBarView.addSubview(notificationButton)

        view.addSubview(logoAndSloganStackView)
        view.addSubview(containerView)
        containerView.addSubview(boardTitleLabel)
        containerView.addSubview(viewAllButton)
        containerView.addSubview(tableView)

        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        logoAndSloganStackView.translatesAutoresizingMaskIntoConstraints = false
        boardTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 상단 상태바와 탑바뷰 흰색 배경
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.bottomAnchor.constraint(equalTo: topBarView.bottomAnchor),

            // Top Bar Layout
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 50),

            menuButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 16),
            menuButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),

            notificationButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor, constant: -16),
            notificationButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),

            // 로고와 슬로건 위치
            logoAndSloganStackView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 20),
            logoAndSloganStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // 그라데이션 아래 컨테이너 뷰
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: logoAndSloganStackView.bottomAnchor, constant: 20),
            containerView.heightAnchor.constraint(equalToConstant: 420),

            boardTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            boardTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

            viewAllButton.centerYAnchor.constraint(equalTo: boardTitleLabel.centerYAnchor),
            viewAllButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: boardTitleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        // 버튼에 액션 연결
        menuButton.addTarget(self, action: #selector(didTapDrawerButton), for: .touchUpInside)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // 구분선 마진 설정
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // 셀 전체 마진 설정
        tableView.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.identifier)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.identifier, for: indexPath) as? BoardTableViewCell else {
            return UITableViewCell()
        }
        let board = viewModel.getBoards()[indexPath.row]
        cell.configure(with: board)
        
        // 셀의 구분선 마진을 테이블 뷰와 동일하게 설정
        cell.separatorInset = tableView.separatorInset
        cell.layoutMargins = tableView.layoutMargins

        return cell
    }


    private func bindViewModel() {
        viewModel.onBoardsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc private func didTapViewAllButton() {
        let boardAllVC = BoardAllViewController()
        navigationController?.pushViewController(boardAllVC, animated: true)
    }

    

    @objc private func didTapDrawerButton() {
        // Admin 여부 확인
        if UserSessionManager.shared.isAdminUser() == true { // Admin이면
            let adminMenuVC = AdminMenuViewController()
            sideMenu = SideMenuNavigationController(rootViewController: adminMenuVC)
        } else { // Admin이 아니면
            let menuVC = MenuViewController()
            sideMenu = SideMenuNavigationController(rootViewController: menuVC)
        }

        // 사이드 메뉴 설정 및 표시
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        present(sideMenu!, animated: true, completion: nil)
    }


    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBoards().count
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBoard = viewModel.getBoards()[indexPath.row]
        let detailVC = BoardDetailViewController()
        detailVC.board = selectedBoard
        navigationController?.pushViewController(detailVC, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
