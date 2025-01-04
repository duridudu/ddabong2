//0105
//안지희
//비밀번호 찾기 뷰

import UIKit
import Alamofire

class FindPasswordViewController: UIViewController {
    var timerLabel: UILabel!
    var messageLabel: UILabel! // 오류 메시지 레이블
    var remainingTime: Int = 300 // 5분 = 300초
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        // 뒤로가기 버튼
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        // 타이틀
        let titleLabel = UILabel()
        titleLabel.text = "비밀번호 찾기"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])

        // 이메일 주소 라벨
        let emailLabel = createLabel(text: "이메일 주소")
        view.addSubview(emailLabel)

        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        // 이메일 입력 필드
        let emailTextField = createTextField(placeholder: "이메일 주소를 입력해주세요.")
        let sendButton = createButton(title: "전송", color: UIColor(hex: "#FF5B35"))
        sendButton.addTarget(self, action: #selector(handleEmailSend), for: .touchUpInside)
        emailTextField.rightView = sendButton
        emailTextField.rightViewMode = .always
        view.addSubview(emailTextField)

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 55) // 폼 높이 조정
        ])

        // 인증번호 라벨
        let authCodeLabel = createLabel(text: "인증번호")
        view.addSubview(authCodeLabel)

        NSLayoutConstraint.activate([
            authCodeLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            authCodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        // 인증번호 입력 필드
        let authCodeTextField = createTextField(placeholder: "인증번호를 입력해주세요.")
        let confirmButton = createButton(title: "확인", color: UIColor(hex: "#A5A2A1"))
        confirmButton.addTarget(self, action: #selector(handleAuthCodeCheck), for: .touchUpInside)
        authCodeTextField.rightView = confirmButton
        authCodeTextField.rightViewMode = .always
        view.addSubview(authCodeTextField)

        NSLayoutConstraint.activate([
            authCodeTextField.topAnchor.constraint(equalTo: authCodeLabel.bottomAnchor, constant: 10),
            authCodeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authCodeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authCodeTextField.heightAnchor.constraint(equalToConstant: 55) // 폼 높이 조정
        ])

        // 오류 메시지 레이블
        messageLabel = UILabel()
        messageLabel.textColor = .red
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.isHidden = true
        view.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: authCodeTextField.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // 타이머 라벨
        timerLabel = UILabel()
        timerLabel.text = "입력대기시간: 05:00"
        timerLabel.font = UIFont.systemFont(ofSize: 14)
        timerLabel.textColor = UIColor(hex: "#515151") // 텍스트 색상 변경
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)

        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        // 시간 연장 버튼
        let extendButton = UIButton()
        extendButton.setTitle("시간연장", for: .normal)
        extendButton.setTitleColor(UIColor(hex: "#292929"), for: .normal)
        extendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        extendButton.translatesAutoresizingMaskIntoConstraints = false
        extendButton.addTarget(self, action: #selector(extendTimer), for: .touchUpInside)
        view.addSubview(extendButton)

        NSLayoutConstraint.activate([
            extendButton.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor),
            extendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // 시간 연장 버튼 밑줄
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(hex: "#292929")
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(underlineView)

        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalTo: extendButton.bottomAnchor, constant: -2),
            underlineView.leadingAnchor.constraint(equalTo: extendButton.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: extendButton.trailingAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    

    @objc func handleEmailSend() {
        // 이메일 전송 로직
        // 여기서 오류처리
    }

    @objc func handleAuthCodeCheck() {
        // 인증번호 확인 로직
    }

    @objc func extendTimer() {
        startTimer()
    }
    

    func startTimer() {
        timer?.invalidate()
        remainingTime = 300
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            timerLabel.text = String(format: "입력대기시간: %02d:%02d", minutes, seconds)
            timerLabel.textColor = UIColor(hex: "#FF5B35") // 타이머 색상만 주황색
        } else {
            timer?.invalidate()
        }
    }

    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#EAEAEA").cgColor
        textField.layer.cornerRadius = 5
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor(hex: "#A5A2A1")
        textField.translatesAutoresizingMaskIntoConstraints = false

        // 왼쪽 여백 추가
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }

    private func createButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // 버튼 글자 크기 증가
        button.layer.cornerRadius = 5
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40) // 버튼 크기 증가
        return button
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#A5A2A1")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}



///프리뷰 보려고 잠깐... 쓰는 코드?
import SwiftUI

// UIViewController를 SwiftUI에서 사용할 수 있도록 확장
struct FindPasswordViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            FindPasswordViewController()
        }
    }
}


