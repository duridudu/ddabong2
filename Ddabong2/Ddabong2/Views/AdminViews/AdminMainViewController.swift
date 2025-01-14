//
//  AdminMainViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/13/25.
//

import UIKit
import SideMenu

class AdminMainViewController: UIViewController {
    // 사이드 메뉴 컨트롤러
    private var sideMenu: SideMenuNavigationController?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupCurveWithShadow()
        setupUI()
        setupSideMenu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        view.backgroundColor = .white

        // 로고와 슬로건 StackView 추가
        view.addSubview(logoAndSloganStackView)
        logoAndSloganStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoAndSloganStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoAndSloganStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])

        // 드로어 버튼
        let drawerButton = UIButton()
        drawerButton.setImage(UIImage(named: "drawer"), for: .normal)
        drawerButton.addTarget(self, action: #selector(didTapDrawerButton), for: .touchUpInside)
        drawerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawerButton)

        NSLayoutConstraint.activate([
            drawerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            drawerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            drawerButton.widthAnchor.constraint(equalToConstant: 24),
            drawerButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        // 타이틀 레이블
        let titleLabel = UILabel()
        titleLabel.text = "관리자 페이지"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: drawerButton.centerYAnchor)
        ])

        // 메뉴 버튼들을 2열로 배치하기 위한 Grid StackView
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 16
        gridStackView.alignment = .fill
        gridStackView.distribution = .fillEqually

        // 첫 번째 줄
        let createMemberButton = AdminMenuButton(title: "회원 생성", iconName: "admin_join")
        createMemberButton.addTarget(self, action: #selector(didTapCreateMemberButton), for: .touchUpInside)

        let memberListButton = AdminMenuButton(title: "회원 목록", iconName: "admin_personlist")
        memberListButton.addTarget(self, action: #selector(didTapMemberListButton), for: .touchUpInside)

        let row1Stack = UIStackView(arrangedSubviews: [createMemberButton, memberListButton])
        row1Stack.axis = .horizontal
        row1Stack.spacing = 16
        row1Stack.alignment = .fill
        row1Stack.distribution = .fillEqually

        // 두 번째 줄
        let writeBoardButton = AdminMenuButton(title: "게시글 작성", iconName: "admin_boardwrite")
        writeBoardButton.addTarget(self, action: #selector(didTapWriteBoardButton), for: .touchUpInside)

        let boardListButton = AdminMenuButton(title: "게시글 조회", iconName: "admin_boardlist")
        boardListButton.addTarget(self, action: #selector(didTapBoardListButton), for: .touchUpInside)

        let row2Stack = UIStackView(arrangedSubviews: [writeBoardButton, boardListButton])
        row2Stack.axis = .horizontal
        row2Stack.spacing = 16
        row2Stack.alignment = .fill
        row2Stack.distribution = .fillEqually

        gridStackView.addArrangedSubview(row1Stack)
        gridStackView.addArrangedSubview(row2Stack)
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridStackView)

        NSLayoutConstraint.activate([
            gridStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 120),
            gridStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            gridStackView.heightAnchor.constraint(equalTo: gridStackView.widthAnchor)
        ])

        for stack in [row1Stack, row2Stack] {
            for button in stack.arrangedSubviews {
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalTo: button.widthAnchor) // 정사각형 유지
                ])
            }
        }
    }

    private func setupSideMenu() {
        let menu = AdminMenuViewController()
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }

    @objc private func didTapDrawerButton() {
        if let sideMenu = sideMenu {
            present(sideMenu, animated: true, completion: nil)
        }
    }

    // MARK: - Button Actions
    @objc private func didTapCreateMemberButton() {
        let createVC = AdminUserCreateViewController()
        navigationController?.pushViewController(createVC, animated: true)
    }

    @objc private func didTapMemberListButton() {
        let listVC = AdminUserListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }

    @objc private func didTapWriteBoardButton() {
        let writeVC = AdminBoardWriteViewController()
        navigationController?.pushViewController(writeVC, animated: true)
    }

    @objc private func didTapBoardListButton() {
        let boardListVC = BoardAllViewController()
        navigationController?.pushViewController(boardListVC, animated: true)
    }
}

class AdminMenuButton: UIButton {
    init(title: String, iconName: String) {
        super.init(frame: .zero)

        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let textLabel = UILabel()
        textLabel.text = title
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [iconImageView, textLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            iconImageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5)
        ])

        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        stackView.isUserInteractionEnabled = false // 터치 이벤트 방해 방지
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI

struct AdminPagePreview: PreviewProvider {
    static var previews: some View {
        // UIViewController를 SwiftUI로 Wrapping
        AdminMainViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // Safe Area를 무시하고 전체 화면으로 보여줌
    }
}

struct AdminMainViewControllerRepresentable: UIViewControllerRepresentable {
    // UIViewController 타입 지정
    func makeUIViewController(context: Context) -> UIViewController {
        return AdminMainViewController() // 미리 볼 뷰 컨트롤러를 반환
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 필요 시 업데이트 작업 (대부분 미리보기에서는 비워둠)
    }
}
