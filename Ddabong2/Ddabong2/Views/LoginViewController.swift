//JH
//로그인과 유저정보 받아오기
//푸시알람 토큰 보내는 코드 추가해야해~~~~~!!!!!!!!!!!!!!!!1

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    // UI 컴포넌트들
    let logoImageView = UIImageView()
    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let errorMessageLabel = UILabel()
    let passwordToggleButton = UIButton()

    let loginViewModel = LoginViewModel()

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


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupGradientBackground() // 그라데이션 추가
        setupCurveWithShadow()    // 곡선과 그림자 추가
        setupUI()                 // UI 설정
        setupBindings()           // ViewModel 바인딩 설정
    }

    private func setupGradientBackground() {
        gradientLayer.frame = CGRect(x: 0, y: 10, width: view.bounds.width, height: 300)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // 곡선과 그림자 추가
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

    //UI 배치

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
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // 로그인 폼
        let loginFormView = UIView()
        loginFormView.translatesAutoresizingMaskIntoConstraints = false
        loginFormView.layer.cornerRadius = 20
        loginFormView.backgroundColor = .white
        loginFormView.layer.shadowColor = UIColor.black.cgColor
        loginFormView.layer.shadowOpacity = 0.1
        loginFormView.layer.shadowOffset = CGSize(width: 0, height: 4)
        loginFormView.layer.shadowRadius = 6
        view.addSubview(loginFormView)

        NSLayoutConstraint.activate([
            loginFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginFormView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            loginFormView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            loginFormView.heightAnchor.constraint(equalToConstant: 120)
        ])

        // 아이디 텍스트 필드
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        idTextField.placeholder = "아이디"
        idTextField.borderStyle = .none
        idTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        loginFormView.addSubview(idTextField)

        let bottomLine1 = UIView()
        bottomLine1.translatesAutoresizingMaskIntoConstraints = false
        bottomLine1.backgroundColor = UIColor.lightGray
        loginFormView.addSubview(bottomLine1)

        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: loginFormView.topAnchor),
            idTextField.leadingAnchor.constraint(equalTo: loginFormView.leadingAnchor),
            idTextField.trailingAnchor.constraint(equalTo: loginFormView.trailingAnchor),
            idTextField.heightAnchor.constraint(equalToConstant: 60),

            bottomLine1.topAnchor.constraint(equalTo: idTextField.bottomAnchor),
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
            passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor),
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

        // 에러 메시지 레이블
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = .red
        errorMessageLabel.font = UIFont.systemFont(ofSize: 14)
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        errorMessageLabel.textAlignment = .center // 텍스트 가운데 정렬
        view.addSubview(errorMessageLabel)

        NSLayoutConstraint.activate([
            errorMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorMessageLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            errorMessageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }

    
    
    //액션
    private func setupBindings() {
        loginViewModel.onLoginSuccess = { [weak self] in

            DispatchQueue.main.async {
                let mainVC = NavigationViewController() // 메인 화면
                let navigationController = UINavigationController(rootViewController: mainVC)
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true)
            }
        }

        loginViewModel.onLoginFailure = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.errorMessageLabel.text = errorMessage
                self?.errorMessageLabel.isHidden = false
            }
        }
    }

    //로그인버튼
    @objc func handleLogin() {
        guard let id = idTextField.text, !id.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorMessageLabel.text = "아이디와 비밀번호를 입력해주세요."
            errorMessageLabel.isHidden = false
            return
        }

        errorMessageLabel.isHidden = true
        loginViewModel.login(id: id, password: password)
    }

    
    //비밀번호 숨김
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    //상단 공백 제거
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
