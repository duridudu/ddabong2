
import UIKit

class ChangePasswordViewController: UIViewController {
    // MARK: - UI Components
    var currentPasswordTextField: UITextField!
    var newPasswordTextField: UITextField!
    var confirmPasswordTextField: UITextField!
    var changeButton: UIButton!
    var currentPasswordErrorLabel: UILabel!
    var newPasswordHintLabel: UILabel!
    var confirmPasswordHintLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    // MARK: - Handle Password Change
    @objc func handleChangePassword() {
        guard let currentPassword = currentPasswordTextField.text,
              let newPassword = newPasswordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return }
        
        if newPassword != confirmPassword {
            showError("새 비밀번호가 일치하지 않습니다.")
            return
        }
        
        // 현재 비밀번호 확인 로직 (예시)
        if currentPassword != "server_password_mock" { // 서버와 일치하지 않는다고 가정
            showError("입력하신 정보가 일치하지 않습니다.")
            return
        }
        
        // API 요청: 비밀번호 변경
        PasswordService.shared.changePassword(newPassword: newPassword) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.showSuccessMessage("비밀번호가 성공적으로 변경되었습니다.")
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.showError(error ?? "비밀번호 변경에 실패했습니다.")
                }
            }
        }
    }

    // MARK: - Form Validation
    @objc func validateForm() {
        let isCurrentPasswordFilled = !(currentPasswordTextField.text?.isEmpty ?? true)
        let isNewPasswordValid = isValidPassword(newPasswordTextField.text ?? "")
        let isConfirmPasswordValid = (newPasswordTextField.text == confirmPasswordTextField.text)

        // 조건 만족 여부에 따른 색상 변경
        newPasswordHintLabel.textColor = isNewPasswordValid ? .systemGreen : .lightGray
        confirmPasswordHintLabel.textColor = isConfirmPasswordValid ? .systemGreen : .lightGray

        if isCurrentPasswordFilled && isNewPasswordValid && isConfirmPasswordValid {
            changeButton.isEnabled = true
            changeButton.backgroundColor = UIColor(hex: "#FF5B35")
        } else {
            changeButton.isEnabled = false
            changeButton.backgroundColor = UIColor(hex: "#A5A2A1")
        }
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    // MARK: - Error and Success Messages
    func showError(_ message: String) {
        currentPasswordErrorLabel.text = message
        currentPasswordErrorLabel.textColor = .red
        currentPasswordErrorLabel.isHidden = false
    }

    func showSuccessMessage(_ message: String) {
        let alert = UIAlertController(title: "성공", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    // MARK: - UI Setup
    func setupUI() {
        // 현재 비밀번호 관련 UI
        currentPasswordTextField = createSecureTextField(placeholder: "현재 비밀번호를 입력해주세요.")
        currentPasswordTextField.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        view.addSubview(currentPasswordTextField)

        currentPasswordErrorLabel = createLabel(text: "")
        currentPasswordErrorLabel.textColor = .red
        currentPasswordErrorLabel.isHidden = true
        view.addSubview(currentPasswordErrorLabel)

        // 새 비밀번호 힌트 레이블
        newPasswordHintLabel = createLabel(text: "8~20자 이내 영문자, 숫자, 특수문자 포함")
        newPasswordHintLabel.textColor = .lightGray
        view.addSubview(newPasswordHintLabel)

        // 새 비밀번호 확인 힌트 레이블
        confirmPasswordHintLabel = createLabel(text: "비밀번호 일치")
        confirmPasswordHintLabel.textColor = .lightGray
        view.addSubview(confirmPasswordHintLabel)

        // AutoLayout (예시)
        NSLayoutConstraint.activate([
            currentPasswordErrorLabel.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 5),
            currentPasswordErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            newPasswordHintLabel.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 5),
            newPasswordHintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            confirmPasswordHintLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 5),
            confirmPasswordHintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func createSecureTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
