import UIKit
import Foundation
class AdminUserCreateViewController: UIViewController {
    
    // UI Components
    private let idTextField = UITextField()
    private let passwordTextField = UITextField()
    private let departmentTextField = UITextField()
    private let jobGroupTextField = UITextField()
    private let nameTextField = UITextField()
    private let joinedAtTextField = UITextField()
    private let groupTextField = UITextField()
    private let createButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        addTopBar() // 상단 바 추가
        
        // Input Fields StackView
        let stackView = UIStackView(arrangedSubviews: [
            createLabeledTextField(labelText: "아이디", textField: idTextField, placeholder: "아이디를 입력하세요."),
            createLabeledTextField(labelText: "기본 패스워드", textField: passwordTextField, placeholder: "비밀번호를 입력하세요."),
            createLabeledTextField(labelText: "소속", textField: departmentTextField, placeholder: "소속을 입력하세요. 예: 남양주센터"),
            createLabeledTextField(labelText: "직무 그룹", textField: jobGroupTextField, placeholder: "직무 그룹 번호를 입력하세요."),
            createLabeledTextField(labelText: "이름", textField: nameTextField, placeholder: "이름을 입력하세요."),
            createLabeledTextField(labelText: "입사일", textField: joinedAtTextField, placeholder: "YYYY-MM-DD 형식으로 입력하세요."),
            createLabeledTextField(labelText: "직군", textField: groupTextField, placeholder: "직군을 입력하세요. 예: F 현장 직군")
        ])
        stackView.axis = .vertical
        stackView.spacing = 24 // 간격 조정
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120), // 간격 조정
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Create Button
        createButton.setTitle("완료", for: .normal)
        createButton.backgroundColor = .systemOrange
        createButton.tintColor = .white
        createButton.layer.cornerRadius = 10
        createButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        view.addSubview(createButton)
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createLabeledTextField(labelText: String, textField: UITextField, placeholder: String) -> UIStackView {
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "7A7A7A")
        
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "EAEAEA").cgColor
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.placeholder = placeholder
        textField.setLeftPadding(10)
        
        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }
    
    @objc private func createUser() {
        guard
            let id = idTextField.text, !id.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let departmentName = departmentTextField.text,
            let departmentEnum = Department.allCases.first(where: { $0.displayName == departmentName }),
            let jobGroup = jobGroupTextField.text, let jobGroupInt = Int(jobGroup),
            let name = nameTextField.text, !name.isEmpty,
            let joinedAt = joinedAtTextField.text, !joinedAt.isEmpty,
            let groupName = groupTextField.text,
            let groupEnum = Group.allCases.first(where: { $0.displayName == groupName })
        else {
            showAlert(message: "모든 필드를 올바르게 입력하세요.")
            return
        }

        let userRequest = UserCreateRequest(
            name: name,
            id: id,
            password: password,
            joinedAt: joinedAt,
            departmentId: departmentEnum.rawValue, // 변환된 Int 값
            jobGroup: jobGroupInt,
            group: groupEnum.rawValue // 변환된 "F", "B" 등 문자열 값
        )
        
        CreateUserService.shared.createUser(request: userRequest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.showAlert(message: "회원 생성 성공: \(response.message)")
                case .failure(let error):
                    self?.showAlert(message: "회원 생성 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    private func addTopBar() {
        // 상단 바 뷰
        let topBar = UIView()
        topBar.backgroundColor = .white
        view.addSubview(topBar)
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 뒤로가기 버튼
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        topBar.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor)
        ])
        
        // 회원 생성 타이틀
        let titleLabel = UILabel()
        titleLabel.text = "회원 생성"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .black
        topBar.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor)
        ])
    }
    
    //뒤로가기
    @objc private func handleBackButton() {
        // 현재 화면 닫기
        self.navigationController?.popViewController(animated: true)
    }

}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
