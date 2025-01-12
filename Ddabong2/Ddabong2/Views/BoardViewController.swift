import UIKit

class BoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupCurveWithShadow()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.fetchBoards(size: 6) // 최신 게시글 4개 가져오기
    }

    private func setupGradientBackground() {
        gradientLayer.frame = CGRect(x: 0, y: 10, width: view.bounds.width, height: 300)
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

    private func setupUI() {
        view.addSubview(logoAndSloganStackView)
        view.addSubview(containerView)
        containerView.addSubview(boardTitleLabel)
        containerView.addSubview(viewAllButton)
        containerView.addSubview(tableView)

        logoAndSloganStackView.translatesAutoresizingMaskIntoConstraints = false
        boardTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoAndSloganStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoAndSloganStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: logoAndSloganStackView.bottomAnchor, constant: 90),
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

    @objc private func didTapViewAllButton() {
        let boardAllVC = BoardAllViewController()
        navigationController?.pushViewController(boardAllVC, animated: true)
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBoards().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.identifier, for: indexPath) as? BoardTableViewCell else {
            return UITableViewCell()
        }
        let board = viewModel.getBoards()[indexPath.row]
        cell.configure(with: board)

        if indexPath.row == viewModel.getBoards().count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
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
