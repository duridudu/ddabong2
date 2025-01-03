//
//  LoginViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/25/24.
//


import UIKit
import Foundation


class LoginViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let forgotPasswordButton = UIButton()
    let passwordToggleButton = UIButton()
    
    let gradientBackgroundView = UIView()  // 배경에 사용할 이미지 뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImage()
        setupLogo()
        setupLoginForm()
        setupLoginButton()
        setupForgotPasswordButton()
    }
    
    func setupBackgroundImage() {
        // 배경 이미지 설정
        let backgroundImage = UIImage(named: "loginback") // loginback 이미지 넣기
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func setupLogo() {
        // 로고 위치 조정
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "loginlogo") // 로고 이미지 이름을 넣어주세요.
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 50 // 원형
        logoImageView.layer.masksToBounds = true
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupLoginForm() {
        // 로그인 폼 영역
        let loginFormView = UIView()
        loginFormView.translatesAutoresizingMaskIntoConstraints = false
        loginFormView.layer.cornerRadius = 20 // 둥근 모서리 처리
        loginFormView.layer.masksToBounds = true
        loginFormView.backgroundColor = .white
        view.addSubview(loginFormView)
        
        NSLayoutConstraint.activate([
            loginFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginFormView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            loginFormView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            loginFormView.heightAnchor.constraint(equalToConstant: 120) // 폼 높이 조정
        ])
        
        // 이메일 텍스트 필드 설정
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "이메일"
        emailTextField.borderStyle = .none
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) // 좌측 여백 추가
        loginFormView.addSubview(emailTextField)
        
        let bottomLine1 = UIView()
        bottomLine1.translatesAutoresizingMaskIntoConstraints = false
        bottomLine1.backgroundColor = UIColor.gray
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
        
        // 비밀번호 텍스트 필드 설정
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .none
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) // 좌측 여백 추가
        passwordTextField.isSecureTextEntry = true
        loginFormView.addSubview(passwordTextField)
        
        let bottomLine2 = UIView()
        bottomLine2.translatesAutoresizingMaskIntoConstraints = false
        bottomLine2.backgroundColor = UIColor.gray
        loginFormView.addSubview(bottomLine2)
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: loginFormView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginFormView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            
            bottomLine2.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            bottomLine2.leadingAnchor.constraint(equalTo: loginFormView.leadingAnchor),
            bottomLine2.trailingAnchor.constraint(equalTo: loginFormView.trailingAnchor),
            bottomLine2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // 비밀번호 눈 아이콘 추가
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
    }
    
    func setupLoginButton() {
        // 로그인 버튼 설정
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor(red: 1.0, green: 0.357, blue: 0.208, alpha: 1.0) // 주황색
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // 볼드 처리
        loginButton.layer.cornerRadius = 10  // 버튼 radius 10
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40), // 간격 조정
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupForgotPasswordButton() {
        // 비밀번호 찾기 버튼 설정
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.setTitle("비밀번호 찾기", for: .normal)
        forgotPasswordButton.setTitleColor(UIColor(hex: "#6E6E6E"), for: .normal)  // 회색 (#6E6E6E)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)  // 폰트 크기 12
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        view.addSubview(forgotPasswordButton)
        
        // 비밀번호 찾기 버튼을 로그인 버튼 기준 오른쪽 끝에 맞추기
        NSLayoutConstraint.activate([
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10)
        ])
        
        // 밑줄 추가
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor(hex: "#6E6E6E") // 같은 색으로 밑줄
        view.addSubview(underline)
        
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 2),
            underline.leadingAnchor.constraint(equalTo: forgotPasswordButton.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: forgotPasswordButton.trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc func togglePasswordVisibility() {
        // 비밀번호 보이기/숨기기 토글
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func handleLogin() {
        // 로그인 버튼 클릭 시 처리
        // 여기에 로그인 처리 코드를 추가하면 됩니다.
    }
    
    @objc func handleForgotPassword() {
        // 비밀번호 찾기 버튼 클릭 시 처리
        // 여기에 비밀번호 찾기 처리 코드를 추가하면 됩니다.
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}


///프리뷰 보려고 잠깐... 쓰는 코드?
import SwiftUI

// SwiftUI Preview를 위한 UIViewController 확장
struct LoginViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            LoginViewController()
        }
        .previewDevice("iPhone 14") // 원하는 기기 선택
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
