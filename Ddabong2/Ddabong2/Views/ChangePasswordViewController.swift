import UIKit

class ChangePasswordViewController: UIViewController {
    
    private let userInfoViewModel = UserInfoViewModel()
    
    private let currentPasswordTextField = UITextField()
    private let newPasswordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let changeButton = UIButton()
    private let errorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // 현재 비밀번호 필드
        currentPasswordTextField.placeholder = "현재 비밀번호"
        currentPasswordTextField.isSecureTextEntry = true
        currentPasswordTextField.borderStyle = .roundedRect
        view.addSubview(currentPasswordTextField)

        // 새 비밀번호 필드
        newPasswordTextField.placeholder = "새 비밀번호"
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.borderStyle = .roundedRect
        view.addSubview(newPasswordTextField)

        // 새 비밀번호 확인 필드
        confirmPasswordTextField.placeholder = "새 비밀번호 확인"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        view.addSubview(confirmPasswordTextField)

        // 변경 버튼
        changeButton.setTitle("변경", for: .normal)
        changeButton.backgroundColor = .systemBlue
        changeButton.layer.cornerRadius = 5
        changeButton.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        view.addSubview(changeButton)

        // 에러 레이블
        errorLabel.textColor = .red
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        view.addSubview(errorLabel)

        // Auto Layout
        currentPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            currentPasswordTextField.widthAnchor.constraint(equalToConstant: 300),

            newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 20),
            newPasswordTextField.widthAnchor.constraint(equalToConstant: 300),

            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 300),

            changeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            changeButton.widthAnchor.constraint(equalToConstant: 100),
            changeButton.heightAnchor.constraint(equalToConstant: 40),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: changeButton.bottomAnchor, constant: 10),
            errorLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
    }

    @objc private func handleChangePassword() {
        // 현재 비밀번호 확인
        guard let currentPasswordInput = currentPasswordTextField.text, !currentPasswordInput.isEmpty else {
            showError("현재 비밀번호를 입력하세요.")
            return
        }

        guard let savedPassword = UserSessionManager.shared.getUserInfo()?.password else {
            showError("저장된 비밀번호를 확인할 수 없습니다.")
            return
        }

        if currentPasswordInput != savedPassword {
            showError("현재 비밀번호가 일치하지 않습니다.")
            return
        }

        // 새 비밀번호 검증
        guard let newPassword = newPasswordTextField.text, validatePassword(newPassword) else {
            showError("새 비밀번호는 8-20자 이내로 영문자, 숫자, 특수문자를 포함해야 합니다.")
            return
        }

        guard let confirmPassword = confirmPasswordTextField.text, newPassword == confirmPassword else {
            showError("새 비밀번호가 일치하지 않습니다.")
            return
        }

        // 비밀번호 변경 요청
        PasswordService.shared.changePassword(newPassword: newPassword) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self.showSuccess("비밀번호가 성공적으로 변경되었습니다.")
                } else {
                    self.showError(errorMessage ?? "비밀번호 변경에 실패했습니다.")
                }
            }
        }
    }

    private func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\\\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\\\":{}|<>]{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    private func showSuccess(_ message: String) {
        errorLabel.isHidden = true
        let alert = UIAlertController(title: "성공", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
}
