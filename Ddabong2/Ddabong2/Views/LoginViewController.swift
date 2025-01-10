//
//  LoginViewController.swift
//  Ddabong2
//

//JH

import Foundation
import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    // UI 컴포넌트들
    let logoImageView = UIImageView()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let forgotPasswordButton = UIButton()
    let passwordToggleButton = UIButton()
    let errorMessageLabel = UILabel()  // 오류 메시지 레이블 추가
    
    let loginViewModel = LoginViewModel()  // ViewModel 인스턴스

    // 상단 배경 그라데이션
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.89, blue: 0.85, alpha: 1.0).cgColor, // 연한 핑크
            UIColor.white.cgColor // 흰색
        ]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupGradientBackground() // 그라데이션 추가
        setupCurveWithShadow()    // 곡선과 그림자 추가
        setupUI()  // UI 설정
        setupBindings()  // ViewModel 바인딩 설정
    }
    
    private func setupGradientBackground() {
        // 그라데이션 레이어 생성
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor, // #FFFFFF (흰색)
            UIColor(red: 1.0, green: 0.89, blue: 0.87, alpha: 1.0).cgColor, // #FFE4DE (연한 핑크)
            UIColor(red: 1.0, green: 0.83, blue: 0.80, alpha: 1.0).cgColor  // #FFD5CB (진한 핑크)
        ]
        gradientLayer.locations = [0.0, 0.64, 1.0] // 색상 위치를 피그마와 동일하게 설정
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 그라데이션 시작점 (위쪽 중앙)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // 그라데이션 끝점 (아래쪽 중앙)
        gradientLayer.frame = view.bounds

        // 레이어 삽입
        view.layer.insertSublayer(gradientLayer, at: 0)
    }



    
    private func setupCurveWithShadow() {
        // 곡선 경로 생성
        let curvePath = UIBezierPath()
        curvePath.move(to: CGPoint(x: 0, y: 300)) // 곡선 시작 위치 아래로 조정
        curvePath.addQuadCurve(to: CGPoint(x: view.bounds.width, y: 300),
                               controlPoint: CGPoint(x: view.bounds.width / 2, y: 200)) // 제어점 조정
        curvePath.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height)) // 오른쪽 아래로
        curvePath.addLine(to: CGPoint(x: 0, y: view.bounds.height)) // 왼쪽 아래로
        curvePath.close()

        // 곡선 레이어 생성
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = curvePath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor

        // 그림자 추가
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.1
        shapeLayer.shadowOffset = CGSize(width: 0, height: 4)
        shapeLayer.shadowRadius = 10

        // 레이어 삽입
        view.layer.insertSublayer(shapeLayer, above: gradientLayer)
    }

    
    //UI관련코드!!!!!!!!!!!!!!!!!!!!!!!!!1
    private func setupUI() {
        // 로고 이미지
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "loginlogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 50
        logoImageView.layer.masksToBounds = true
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60), // 로고 위치 조정
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 로그인 폼 (그림자 추가)
        let loginFormView = UIView()
        loginFormView.translatesAutoresizingMaskIntoConstraints = false
        loginFormView.layer.cornerRadius = 20
        loginFormView.backgroundColor = .white
        loginFormView.layer.shadowColor = UIColor.black.cgColor
        loginFormView.layer.shadowOpacity = 0.1 // 그림자 투명도
        loginFormView.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        loginFormView.layer.shadowRadius = 6 // 그림자 퍼짐 정도
        view.addSubview(loginFormView)
        
        NSLayoutConstraint.activate([
            loginFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginFormView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            loginFormView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            loginFormView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // 이메일 텍스트 필드
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "이메일"
        emailTextField.borderStyle = .none
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        loginFormView.addSubview(emailTextField)
        
        let bottomLine1 = UIView()
        bottomLine1.translatesAutoresizingMaskIntoConstraints = false
        bottomLine1.backgroundColor = UIColor.lightGray
        loginFormView.addSubview(bottomLine1)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: loginFormView.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: loginFormView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: loginFormView.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            bottomLine1.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            bottomLine1.leadingAnchor.constraint(equalTo: loginFormView.leadingAnchor),
            bottomLine1.trailingAnchor.constraint(equalTo: loginFormView.trailingAnchor),
            bottomLine1.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // 비밀번호 텍스트 필드
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .none
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        passwordTextField.isSecureTextEntry = true
        loginFormView.addSubview(passwordTextField)
    
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: loginFormView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginFormView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // 비밀번호 눈 아이콘
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleButton.tintColor = UIColor.gray
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        loginFormView.addSubview(passwordToggleButton)
        
        NSLayoutConstraint.activate([
            passwordToggleButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -10),
            passwordToggleButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            passwordToggleButton.widthAnchor.constraint(equalToConstant: 30),
            passwordToggleButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // 로그인 버튼
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor(red: 1.0, green: 0.357, blue: 0.208, alpha: 1.0)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: loginFormView.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }

    
    func setupBindings() {
        loginViewModel.onLoginSuccess = { [weak self] user in
            DispatchQueue.main.async {
                let scheduleVC = ScheduleViewController()
                self?.navigationController?.pushViewController(scheduleVC, animated: true)
            }
        }
        
        loginViewModel.onLoginFailure = { [weak self] _ in
            DispatchQueue.main.async {
                self?.errorMessageLabel.text = "이메일 또는 비밀번호를 확인해 주세요."
                self?.errorMessageLabel.isHidden = false
            }
        }
    }
    
    
    
    //액션!!!!!!!!!!!!!!!!!!!!!
    @objc func handleLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorMessageLabel.text = "이메일과 비밀번호를 입력하세요."
            errorMessageLabel.isHidden = false
            return
        }
        loginViewModel.loginUser(email: email, password: password)
    }
    

    
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    //여백삭제
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.setNavigationBarHidden(true, animated: false)
       }


}


///프리뷰 보려고 잠깐... 쓰는 코드?
import SwiftUI

// SwiftUI Preview를 위한 UIViewController 확장
struct LoginViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            UINavigationController(rootViewController: LoginViewController())
        }
    }
}

struct UIViewControllerPreview: UIViewControllerRepresentable {
    let viewController: () -> UIViewController

    init(_ viewController: @escaping () -> UIViewController) {
        self.viewController = viewController
    }

    // UIViewController를 생성
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController()
    }

    // 업데이트 처리
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
