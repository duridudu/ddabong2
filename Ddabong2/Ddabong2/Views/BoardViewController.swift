// BoardViewController.swift
// Ddabong2
//
// Created by 이윤주 on 12/25/24.
//

import UIKit

class BoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //인스턴스 생성
    private let viewModel = BoardViewModel() //뷰모델
    private let tableView = UITableView() //테이블뷰
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    // 상단 배경 그라데이션
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.cgColor, // 위쪽 흰색
            UIColor(red: 1.0, green: 0.96, blue: 0.92, alpha: 1.0).cgColor, // 중간 연한 핑크
            UIColor(red: 1.0, green: 0.84, blue: 0.80, alpha: 1.0).cgColor  // 아래쪽 진한 핑크
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0] // 색상 위치
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 그라데이션 시작점 (위쪽 중앙)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // 그라데이션 끝점 (아래쪽 중앙)
        return gradientLayer
    }()

    private func setupCurveWithShadow() {
        // 곡선 경로 생성
        let curvePath = UIBezierPath()
        curvePath.move(to: CGPoint(x: 0, y: 200)) // 곡선 시작
        curvePath.addQuadCurve(to: CGPoint(x: view.bounds.width, y: 200), // 끝 점
                               controlPoint: CGPoint(x: view.bounds.width / 2, y: 150)) // Control Point
        curvePath.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height)) // 오른쪽 아래로
        curvePath.addLine(to: CGPoint(x: 0, y: view.bounds.height)) // 왼쪽 아래로
        curvePath.close()

        // 곡선 레이어 생성
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = curvePath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor

        // 그림자 추가
        shapeLayer.shadowColor = UIColor.black.cgColor // 그림자 색상
        shapeLayer.shadowOpacity = 0.4 // 그림자 투명도
        shapeLayer.shadowOffset = CGSize(width: 0, height: 10) // 그림자 아래로 이동
        shapeLayer.shadowRadius = 10 // 그림자 퍼짐 정도

        // 레이어 삽입
        view.layer.insertSublayer(shapeLayer, at: 1)
    }



    private func setupGradientBackground() {
        // 그라데이션 레이어 크기 설정
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 260)
        
        // 레이어 삽입
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    // 슬로건 라벨
    private let sloganLogoStackView: UIStackView = {
        let label = UILabel()
        label.text = "멈추지 않는 도전,"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 1.0) // FF5B35
        label.textAlignment = .right

        let imageView = UIImageView()
        imageView.image = UIImage(named: "boardlogo") // 로고 이미지
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 160).isActive = true  // 로고 너비
        imageView.heightAnchor.constraint(equalToConstant: 45.5).isActive = true // 로고 높이

        imageView.contentMode = .scaleAspectFit

        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.spacing = 2 // 라벨과 로고 사이 간격
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()



    // 게시판 제목
    private let boardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시판"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()

    // 전체보기 버튼
    private let viewAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체보기 >", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()

   

    // 플로팅 버튼
    private let floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .orange
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground() // 그라데이션 추가
        setupCurveWithShadow()    // 곡선과 그림자 추가
        setupUI()
        setupTableView()
        edgesForExtendedLayout = []
        viewModel.fetchBoards() // ViewModel에서 데이터 가져오기
    }
    


    // 곡선 추가
    private func setupCurve() {
        let curvePath = UIBezierPath()
        curvePath.move(to: CGPoint(x: 0, y: 200))
        curvePath.addQuadCurve(to: CGPoint(x: view.bounds.width, y: 200),
                               controlPoint: CGPoint(x: view.bounds.width / 2, y: 100))
        curvePath.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        curvePath.addLine(to: CGPoint(x: 0, y: view.bounds.height))
        curvePath.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = curvePath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        view.layer.insertSublayer(shapeLayer, at: 1)
    }

    private func setupUI() {
        // 전체보기 버튼 액션 연결
            viewAllButton.addTarget(self, action: #selector(didTapViewAllButton), for: .touchUpInside)

        // 슬로건과 로고 StackView
        view.addSubview(sloganLogoStackView)
        sloganLogoStackView.translatesAutoresizingMaskIntoConstraints = false

        // 게시판 제목과 전체보기 버튼
        view.addSubview(boardTitleLabel)
        boardTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAllButton)
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false

        // 플로팅 버튼
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false

        // Auto Layout
        NSLayoutConstraint.activate([
            // 슬로건과 로고 StackView
            sloganLogoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            sloganLogoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // 게시판 제목
            boardTitleLabel.topAnchor.constraint(equalTo: sloganLogoStackView.bottomAnchor, constant: 120),
            boardTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            // 전체보기 버튼
            viewAllButton.centerYAnchor.constraint(equalTo: boardTitleLabel.centerYAnchor),
            viewAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // 플로팅 버튼
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

        
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BoardCell")

        // 테이블 뷰 레이아웃
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: boardTitleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

    

    // MARK: - TableView DataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.boards.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath)
            let board = viewModel.boards[indexPath.row]
            cell.textLabel?.text = board.title
            cell.detailTextLabel?.text = board.createdAt
            return cell
        }
    
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 게시글 데이터를 가져옴
        let selectedBoard = viewModel.boards[indexPath.row]
        
        // BoardDetailViewController로 이동
        let detailVC = BoardDetailViewController()
        detailVC.board = selectedBoard // 선택한 게시글 데이터 전달
        navigationController?.pushViewController(detailVC, animated: true)
    }

    

    
    
    //액션!!!!!!!!!!
    //전체보기 버튼 이동
    @objc private func didTapViewAllButton() {
        let boardAllVC = BoardAllViewController()
        navigationController?.pushViewController(boardAllVC, animated: true)
    }
}




import SwiftUI

struct BoardViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let boardVC = BoardViewController()
            return UINavigationController(rootViewController: boardVC)
        }
    }
}
