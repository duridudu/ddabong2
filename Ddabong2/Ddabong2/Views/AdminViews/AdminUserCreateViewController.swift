import UIKit

class AdminUserCreateViewController: UIViewController {
    // MARK: - UI Components
    private let idTextField = UITextField()
    private let idCheckButton = UIButton()
    private let passwordTextField = UITextField()
    private let departmentTextField = UITextField()
    private let jobGroupTextField = UITextField()
    private let nameTextField = UITextField()
    private let joinedAtTextField = UITextField()
    private let groupTextField = UITextField()
    private let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        navigationItem.title = "회원 생성"
        
        let backButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
        
        let completeButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(handleSubmit))
        navigationItem.rightBarButtonItem = completeButton
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // 아이디 필드와 중복확인 버튼을 담는 스택뷰
        let idStackView = UIStackView(arrangedSubviews: [
            createInputField(idTextField, placeholder: "아이디"),
            idCheckButton
        ])
        idStackView.axis = .horizontal
        idStackView.spacing = 10
        
        idCheckButton.setTitle("중복확인", for: .normal)
        idCheckButton.backgroundColor = .systemOrange
        idCheckButton.layer.cornerRadius = 5
        idCheckButton.addTarget(self, action: #selector(handleIdCheck), for: .touchUpInside)
        
        // 스택뷰 설정
        let stackView = UIStackView(arrangedSubviews: [
            idStackView,
            createInputField(passwordTextField, placeholder: "기본 패스워드"),
            createInputField(departmentTextField, placeholder: "소속"),
            createInputField(jobGroupTextField, placeholder: "직무그룹"),
            createInputField(nameTextField, placeholder: "이름"),
            createInputField(joinedAtTextField, placeholder: "입사일 (YYYY.MM.DD)"),
            createInputField(groupTextField, placeholder: "직군")
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func createInputField(_ textField: UITextField, placeholder: String) -> UIView {
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }
    
    // MARK: - Actions
    @objc private func handleIdCheck() {
        // TODO: 아이디 중복확인 로직 구현
        print("아이디 중복확인 버튼 클릭")
    }
    
    @objc private func handleSubmit() {
        guard let id = idTextField.text,
              let password = passwordTextField.text,
              let departmentId = departmentTextField.text,
              let jobGroup = jobGroupTextField.text,
              let name = nameTextField.text,
              let joinedAt = joinedAtTextField.text,
              let group = groupTextField.text else {
            showErrorAlert(message: "모든 필드를 입력해주세요.")
            return
        }
        
        let parameters: [String: Any] = [
            "id": id,
            "password": password,
            "departmentId": Int(departmentId) ?? 0,
            "jobGroup": Int(jobGroup) ?? 0,
            "name": name,
            "joinedAt": joinedAt,
            "group": group
        ]
        
        CreateUserService.shared.createUser(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    self?.showSuccessAlert(message: message)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "성공", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
