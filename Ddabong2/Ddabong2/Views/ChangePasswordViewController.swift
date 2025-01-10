//
//  ChangePasswordViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/4/25.
//



import UIKit

class ChangePasswordViewController: UIViewController {
    var currentPasswordTextField: UITextField!
    var newPasswordTextField: UITextField!
    var confirmPasswordTextField: UITextField!
    var changeButton: UIButton!
    var currentPasswordErrorLabel: UILabel!
    var newPasswordValidationLabel: UILabel!
    var confirmPasswordValidationLabel: UILabel!

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
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        // 타이틀
        let titleLabel = UILabel()
        titleLabel.text = "비밀번호 변경"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])

        // 변경 버튼 (오른쪽 상단)
        changeButton = UIButton(type: .system)
        changeButton.setTitle("변경", for: .normal)
        changeButton.backgroundColor = UIColor(hex: "#A5A2A1") // 비활성화 색상
        changeButton.setTitleColor(.white, for: .normal)
        changeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        changeButton.layer.cornerRadius = 5
        changeButton.isEnabled = false
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        changeButton.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        view.addSubview(changeButton)

        NSLayoutConstraint.activate([
            changeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            changeButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            changeButton.widthAnchor.constraint(equalToConstant: 60),
            changeButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        // 현재 비밀번호 필드
        let currentPasswordLabel = createLabel(text: "현재 비밀번호")
        view.addSubview(currentPasswordLabel)

        NSLayoutConstraint.activate([
            currentPasswordLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            currentPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        currentPasswordTextField = createSecureTextField(placeholder: "현재 비밀번호를 입력해주세요.")
        currentPasswordTextField.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        view.addSubview(currentPasswordTextField)

        NSLayoutConstraint.activate([
            currentPasswordTextField.topAnchor.constraint(equalTo: currentPasswordLabel.bottomAnchor, constant: 10),
            currentPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currentPasswordTextField.heightAnchor.constraint(equalToConstant: 55)
        ])

        // 현재 비밀번호 오류 메시지
        currentPasswordErrorLabel = createErrorLabel()
        view.addSubview(currentPasswordErrorLabel)

        NSLayoutConstraint.activate([
            currentPasswordErrorLabel.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 5),
            currentPasswordErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentPasswordErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // 새 비밀번호 필드
        let newPasswordLabel = createLabel(text: "새 비밀번호")
        view.addSubview(newPasswordLabel)

        NSLayoutConstraint.activate([
            newPasswordLabel.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 30),
            newPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        newPasswordTextField = createSecureTextField(placeholder: "새 비밀번호를 입력해주세요.")
        newPasswordTextField.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        view.addSubview(newPasswordTextField)

        NSLayoutConstraint.activate([
            newPasswordTextField.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: 10),
            newPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 55)
        ])

        // 새 비밀번호 유효성 검증 라벨
        newPasswordValidationLabel = createValidationLabel()
        view.addSubview(newPasswordValidationLabel)

        NSLayoutConstraint.activate([
            newPasswordValidationLabel.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 5),
            newPasswordValidationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newPasswordValidationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // 새 비밀번호 확인 필드
        let confirmPasswordLabel = createLabel(text: "새 비밀번호 확인")
        view.addSubview(confirmPasswordLabel)

        NSLayoutConstraint.activate([
            confirmPasswordLabel.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 30),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        confirmPasswordTextField = createSecureTextField(placeholder: "새 비밀번호를 다시 입력해주세요.")
        confirmPasswordTextField.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        view.addSubview(confirmPasswordTextField)

        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 10),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 55)
        ])

        // 비밀번호 확인 유효성 검증 라벨
        confirmPasswordValidationLabel = createValidationLabel()
        view.addSubview(confirmPasswordValidationLabel)

        NSLayoutConstraint.activate([
            confirmPasswordValidationLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 5),
            confirmPasswordValidationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmPasswordValidationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleChangePassword() {
        // 비밀번호 변경 로직
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func validateForm() {
        let isCurrentPasswordFilled = !(currentPasswordTextField.text?.isEmpty ?? true)
        let isNewPasswordValid = isValidPassword(newPasswordTextField.text ?? "")
        let isConfirmPasswordValid = (newPasswordTextField.text == confirmPasswordTextField.text)

        if isCurrentPasswordFilled && isNewPasswordValid && isConfirmPasswordValid {
            changeButton.isEnabled = true
            changeButton.backgroundColor = UIColor(hex: "#FF5B35") // 활성화된 색상
        } else {
            changeButton.isEnabled = false
            changeButton.backgroundColor = UIColor(hex: "#A5A2A1") // 비활성화된 색상
        }
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    private func createSecureTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#EAEAEA").cgColor
        textField.layer.cornerRadius = 5
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .black
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false

        // 왼쪽 간격 추가
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 44))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        // 오른쪽 눈 아이콘
        let eyeButton = UIButton(type: .system)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.tintColor = UIColor(hex: "#A5A2A1")
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        textField.rightView = eyeButton
        textField.rightViewMode = .always
        return textField
    }

    @objc func togglePasswordVisibility(_ sender: UIButton) {
        guard let textField = sender.superview as? UITextField else { return }
        textField.isSecureTextEntry.toggle()
        sender.setImage(UIImage(systemName: textField.isSecureTextEntry ? "eye" : "eye.slash"), for: .normal)
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#A5A2A1")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createErrorLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }

    private func createValidationLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    //여백삭제
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.setNavigationBarHidden(true, animated: false)
       }

}

///프리뷰 추가
import SwiftUI

struct ChangePasswordViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ChangePasswordViewController()
        }
    }
}
