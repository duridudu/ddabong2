import UIKit

class AdminUserCreateViewController: UIViewController {
    // UI 요소 선언
    let idLabel = UILabel()
    let idTextField = UITextField()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let departmentLabel = UILabel()
    let departmentTextField = UITextField()
    let jobGroupLabel = UILabel()
    let jobGroupTextField = UITextField()
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let joinedAtLabel = UILabel()
    let joinedAtTextField = UITextField()
    let groupLabel = UILabel()
    let groupTextField = UITextField()
    let backButton = UIButton()
    let doneButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // UI 초기화
    private func setupUI() {
        view.backgroundColor = .white

        // 상단 뒤로가기 버튼 설정
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)

        // 상단 완료 버튼 설정
        doneButton.setTitle("완료", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        doneButton.addTarget(self, action: #selector(handleCreateUser), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)

        // 레이블과 TextField 구성
        configureLabel(idLabel, text: "아이디")
        configureTextField(idTextField, placeholder: "아이디를 입력하세요")
        configureLabel(passwordLabel, text: "기본 패스워드")
        configureTextField(passwordTextField, placeholder: "비밀번호를 입력하세요")
        configureLabel(departmentLabel, text: "소속")
        configureTextField(departmentTextField, placeholder: "소속을 입력하세요")
        configureLabel(jobGroupLabel, text: "직무 그룹")
        configureTextField(jobGroupTextField, placeholder: "직무 그룹을 입력하세요")
        configureLabel(nameLabel, text: "이름")
        configureTextField(nameTextField, placeholder: "이름을 입력하세요")
        configureLabel(joinedAtLabel, text: "입사일")
        configureTextField(joinedAtTextField, placeholder: "YYYY-MM-DD")
        configureLabel(groupLabel, text: "직군")
        configureTextField(groupTextField, placeholder: "직군을 입력하세요")

        // StackView로 UI 구성
        let stackView = UIStackView(arrangedSubviews: [
            idLabel, idTextField,
            passwordLabel, passwordTextField,
            departmentLabel, departmentTextField,
            jobGroupLabel, jobGroupTextField,
            nameLabel, nameTextField,
            joinedAtLabel, joinedAtTextField,
            groupLabel, groupTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단 버튼 제약 조건
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // StackView 제약 조건
            stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }

    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
    }

    // 뒤로가기 동작
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil)
    }

    // 회원 생성 처리
    @objc private func handleCreateUser() {
        guard let id = idTextField.text, !id.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let department = departmentTextField.text, let departmentId = Int(department),
              let jobGroup = jobGroupTextField.text, let jobGroupId = Int(jobGroup),
              let name = nameTextField.text, !name.isEmpty,
              let joinedAt = joinedAtTextField.text, !joinedAt.isEmpty,
              let group = groupTextField.text, !group.isEmpty else {
            showAlert(message: "모든 필드를 채워주세요.")
            return
        }

        CreateUserService.shared.createUser(name: name, id: id, password: password, joinedAt: joinedAt, departmentId: departmentId, jobGroup: jobGroupId, group: group) { [weak self] success, errorMessage in
            if success {
                DispatchQueue.main.async {
                    self?.showAlert(message: "회원 생성 완료", isSuccess: true)
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage ?? "회원 생성 실패")
                }
            }
        }
    }

    private func showAlert(message: String, isSuccess: Bool = false) {
        let alert = UIAlertController(title: isSuccess ? "성공" : "실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            if isSuccess {
                self.dismiss(animated: true, completion: nil)
            }
        })
        present(alert, animated: true, completion: nil)
    }
}
