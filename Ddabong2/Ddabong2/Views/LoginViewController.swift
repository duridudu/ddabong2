//
//  LoginViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/25/24.
//


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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()  // UI 설정
        setupBindings()  // ViewModel 바인딩 설정
    }
    
    // UI 설정
    func setupUI() {
        // 배경 이미지 설정
        let backgroundImage = UIImage(named: "loginback")
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        // 로고 위치 조정
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "loginlogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 50
        logoImageView.layer.masksToBounds = true
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 로그인 폼
        let loginFormView = UIView()
        loginFormView.translatesAutoresizingMaskIntoConstraints = false
        loginFormView.layer.cornerRadius = 20
        loginFormView.layer.masksToBounds = true
        loginFormView.backgroundColor = .white
        view.addSubview(loginFormView)
        
        NSLayoutConstraint.activate([
            loginFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginFormView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            loginFormView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            loginFormView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // 이메일 텍스트 필드
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "이메일"
        emailTextField.borderStyle = .none
        emailTextField.textColor = .black
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
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
        
        // 비밀번호 텍스트 필드
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .none
        passwordTextField.textColor = .black
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
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
        
        // 비밀번호 눈 아이콘
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleButton.tintColor = UIColor.gray
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        loginFormView.addSubview(passwordToggleButton)
        
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "이메일",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )

        
        
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
            loginButton.topAnchor.constraint(equalTo: loginFormView.bottomAnchor, constant: 40),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    
        
        // 비밀번호 찾기 버튼
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.setTitle("비밀번호 찾기", for: .normal)
        forgotPasswordButton.setTitleColor(UIColor(hex: "#6E6E6E"), for: .normal) // 텍스트 색상 설정
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        view.addSubview(forgotPasswordButton)

        // 버튼 밑줄 추가
        let forgotPasswordUnderline = UIView()
        forgotPasswordUnderline.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordUnderline.backgroundColor = UIColor(hex: "#6E6E6E") // 버튼 텍스트와 동일한 색상
        view.addSubview(forgotPasswordUnderline)

        // 비밀번호 찾기 버튼 제약 조건
        NSLayoutConstraint.activate([
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10)
        ])

        // 밑줄 제약 조건
        NSLayoutConstraint.activate([
            forgotPasswordUnderline.topAnchor.constraint(equalTo: forgotPasswordButton.titleLabel!.bottomAnchor, constant: 2),
            forgotPasswordUnderline.centerXAnchor.constraint(equalTo: forgotPasswordButton.centerXAnchor),
            forgotPasswordUnderline.widthAnchor.constraint(equalTo: forgotPasswordButton.titleLabel!.widthAnchor),
            forgotPasswordUnderline.heightAnchor.constraint(equalToConstant: 1) // 밑줄 두께
        ])

        
        
        // 오류 메시지 레이블 위치 조정
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = .red
        errorMessageLabel.font = UIFont.systemFont(ofSize: 12)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.isHidden = true
        view.addSubview(errorMessageLabel)

        // 오류 메시지 레이블 제약 조건 변경
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalTo: loginFormView.bottomAnchor, constant: 10), // 로그인 폼 아래
            errorMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorMessageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])

        // 로그인 버튼 제약 조건 변경
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 10), // 오류 메시지 아래
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
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


    
    //로그인버튼 액션
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
    }
    
    
    @objc func handleForgotPassword() {
        // FindPasswordViewController로 화면 이동
        let resetPasswordVC = FindPasswordViewController()
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }

    
}



//색상코드사용하기!!!
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
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
