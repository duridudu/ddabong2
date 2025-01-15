import UIKit
import Alamofire
class AdminUserCreateViewController: UIViewController {
    
    let departments = ["음성 1센터", "음성 2센터", "용인백암센터", "남양주센터", "파주센터", "사업기획팀", "그로스팀", "CX팀"]
    let groups = ["F 현장 직군", "B 관리 직군", "G 성장 전략", "T 기술 직군"]


    // UI 요소들
    private let idLabel = UILabel()
    private let idTextField = UITextField()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let departmentLabel = UILabel()
    private let departmentIdTextField = UITextField()
    private let jobGroupLabel = UILabel()
    private let jobGroupTextField = UITextField()
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let joinedAtLabel = UILabel()
    private let joinedAtTextField = UITextField()
    private let groupLabel = UILabel()
    private let groupTextField = UITextField()
    private let checkDuplicateButton = UIButton() // 아이디 중복 확인 버튼

    //상단바
    private let customNavBar = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let completeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // UI 설정
        setupUI()
        
        //상단바
        setupCustomNavBar()
        
        setupCustomDropDown(for: departmentIdTextField, with: departments)
        setupCustomDropDown(for: groupTextField, with: groups)

        
        //패딩
        addPaddingToTextField(idTextField, padding: 16)
        addPaddingToTextField(passwordTextField, padding: 16)
        addPaddingToTextField(departmentIdTextField, padding: 16)
        addPaddingToTextField(jobGroupTextField, padding: 16)
        addPaddingToTextField(nameTextField, padding: 16)
        addPaddingToTextField(joinedAtTextField, padding: 16)
        addPaddingToTextField(groupTextField, padding: 16)

    }
    
    // 상단 커스텀 네비게이션 바 설정
    private func setupCustomNavBar() {
        // 네비게이션 바 커스텀 뷰 설정
        customNavBar.backgroundColor = .white
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavBar)
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 뒤로가기 버튼 설정
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        customNavBar.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor)
        ])
        
        // 타이틀 레이블 설정
        titleLabel.text = "회원 생성"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: customNavBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor)
        ])
        
        // 완료 버튼 설정
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = UIColor(hex: "#FF5B35")
        completeButton.layer.cornerRadius = 16
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.addTarget(self, action: #selector(handleCompleteButton), for: .touchUpInside)
        customNavBar.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor, constant: -16),
            completeButton.centerYAnchor.constraint(equalTo: customNavBar.centerYAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 60),
            completeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCustomDropDown(for textField: UITextField, with items: [String]) {
        let dropDownButton = UIButton(type: .system)
        
        // 아이콘 크기 조정
        let icon = UIImage(systemName: "arrowtriangle.down.fill")?
            .withRenderingMode(.alwaysTemplate) // Tint 적용
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 10)) // 원하는 크기로 설정

        dropDownButton.setImage(icon, for: .normal)
        dropDownButton.tintColor = .gray

        // 공백 글자 추가 (크기: 13pt)
        dropDownButton.setTitle("   ", for: .normal) // 공백 글자를 추가
        dropDownButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        dropDownButton.titleLabel?.textColor = .clear // 텍스트 색상을 투명하게 설정

        // 버튼 크기 조정
        dropDownButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        dropDownButton.addTarget(self, action: #selector(showDropDown(sender:)), for: .touchUpInside)

        textField.rightView = dropDownButton
        textField.rightViewMode = .always

        // 드롭다운 데이터 연결
        dropDownButton.tag = textField == departmentIdTextField ? 1 : 2 // 태그로 구분
    }


    @objc private func showDropDown(sender: UIButton) {
        let dropDownItems = sender.tag == 1 ? departments : groups
        let targetTextField = sender.tag == 1 ? departmentIdTextField : groupTextField

        // 드롭다운 위치 및 크기 설정
        let dropDownFrame = CGRect(
            x: targetTextField.frame.origin.x,
            y: targetTextField.frame.origin.y + targetTextField.frame.height + 5,
            width: targetTextField.frame.width,
            height: CGFloat(min(dropDownItems.count, 4)) * 30 // 최대 5줄 표시
        )

        // 드롭다운 뷰 생성 및 추가
        let dropDownView = CustomDropDownView(items: dropDownItems, frame: dropDownFrame) { [weak self] selectedItem in
            targetTextField.text = selectedItem
        }

        self.view.addSubview(dropDownView)
    }


    // UI 설정 메서드
    private func setupUI() {
        // 뷰의 배경 색상 설정
        view.backgroundColor = .white
        
        // 라벨 설정
        setupLabel(idLabel, text: "아이디")
        setupLabel(passwordLabel, text: "기본 패스워드")
        setupLabel(departmentLabel, text: "소속")
        setupLabel(jobGroupLabel, text: "직무그룹")
        setupLabel(nameLabel, text: "이름")
        setupLabel(joinedAtLabel, text: "입사일")
        setupLabel(groupLabel, text: "직군")
    
    
        // TextField 설정
        [idTextField, passwordTextField, departmentIdTextField, jobGroupTextField, nameTextField, joinedAtTextField, groupTextField].forEach {
            $0.borderStyle = .none
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor(hex: "#EAEAEA").cgColor
            $0.layer.cornerRadius = 10
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
            view.addSubview($0)
        }
        
        idTextField.placeholder = "아이디를 입력하세요"
        passwordTextField.placeholder = "비밀번호를 입력하세요"
        departmentIdTextField.placeholder = "소속을 선택하세요"
        jobGroupTextField.placeholder = "1"
        nameTextField.placeholder = "이름을 입력하세요"
        joinedAtTextField.placeholder = "YYYY-MM-DD"
        groupTextField.placeholder = "직군을 선택하세요"
        
        // 중복 확인 버튼 추가
        checkDuplicateButton.setTitle("중복확인", for: .normal)
        checkDuplicateButton.setTitleColor(.white, for: .normal)
        checkDuplicateButton.backgroundColor = UIColor(hex: "#FF5B35")
        checkDuplicateButton.layer.cornerRadius = 8
        checkDuplicateButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        checkDuplicateButton.translatesAutoresizingMaskIntoConstraints = false
        checkDuplicateButton.addTarget(self, action: #selector(handleDuplicateCheck), for: .touchUpInside)
        view.addSubview(checkDuplicateButton)

        

        // AutoLayout 설정
        setupConstraints()
    }
 
    
    @objc private func handleDuplicateCheck() {
        guard let id = idTextField.text, !id.isEmpty else {
            showAlert(message: "아이디를 입력해주세요.")
            return
        }

        // DuplicateCheckService 호출
        DuplicateCheckService.shared.checkDuplicate(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isAvailable):
                    if isAvailable {
                        self?.idTextField.layer.borderColor = UIColor.green.cgColor
                        self?.showAlert(message: "사용 가능한 아이디입니다.")
                    } else {
                        self?.idTextField.layer.borderColor = UIColor.red.cgColor
                        self?.showAlert(message: "아이디가 중복되었습니다.")
                    }
                case .failure(let error):
                    self?.idTextField.layer.borderColor = UIColor.orange.cgColor
                    self?.showAlert(message: "중복 확인 중 에러가 발생했습니다: \(error.localizedDescription)")
                }
            }
        }
    }



    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.textColor = UIColor(hex: "7A7A7A") // 텍스트 색상 변경
        label.font = UIFont.systemFont(ofSize: 15) // 글씨 크기 변경
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    }

    // AutoLayout 제약 설정
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            idLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            idTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 13),
            idTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            idTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            checkDuplicateButton.centerYAnchor.constraint(equalTo: idTextField.centerYAnchor),
            checkDuplicateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            checkDuplicateButton.widthAnchor.constraint(equalToConstant: 80),
            checkDuplicateButton.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            
            passwordLabel.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 13),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            departmentLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            departmentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            departmentIdTextField.topAnchor.constraint(equalTo: departmentLabel.bottomAnchor, constant: 13),
            departmentIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            departmentIdTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),

            jobGroupLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            jobGroupLabel.leadingAnchor.constraint(equalTo: departmentIdTextField.trailingAnchor, constant: 24),

            jobGroupTextField.topAnchor.constraint(equalTo: jobGroupLabel.bottomAnchor, constant: 13),
            jobGroupTextField.leadingAnchor.constraint(equalTo: departmentIdTextField.trailingAnchor, constant: 24),
            jobGroupTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            jobGroupTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            nameLabel.topAnchor.constraint(equalTo: departmentIdTextField.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            joinedAtLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            joinedAtLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            joinedAtTextField.topAnchor.constraint(equalTo: joinedAtLabel.bottomAnchor, constant: 13),
            joinedAtTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            joinedAtTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            groupLabel.topAnchor.constraint(equalTo: joinedAtTextField.bottomAnchor, constant: 20),
            groupLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            groupTextField.topAnchor.constraint(equalTo: groupLabel.bottomAnchor, constant: 13),
            groupTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            groupTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
            
            
        ])
    }

    @objc private func handleCreateUser() {
        guard let id = idTextField.text, !id.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let departmentName = departmentIdTextField.text,
              let department = Department.from(departmentName),
              let jobGroupText = jobGroupTextField.text,
              let jobGroup = Int(jobGroupText),
              let name = nameTextField.text, !name.isEmpty,
              let joinedAt = joinedAtTextField.text, !joinedAt.isEmpty,
              let groupName = groupTextField.text,
              let group = Group.from(groupName) else {
            showAlert(message: "모든 필드를 올바르게 입력해주세요.")
            return
        }

        let newUser = UserCreateRequest(
            name: name,
            id: id,
            password: password,
            joinedAt: joinedAt,
            departmentId: department.id, // 부서 ID 변환 값
            jobGroup: jobGroup,
            group: group.code // 직군 코드 변환 값
        )

        UserService.shared.createUser(user: newUser) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isSuccess):
                    if isSuccess {
                        // 회원 생성 성공
                        let alert = UIAlertController(
                            title: "회원 생성 완료",
                            message: "회원 생성이 성공적으로 완료되었습니다.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true) // 이전 화면으로 이동
                        })
                        self.present(alert, animated: true)
                    } else {
                        self.showAlert(message: "회원 생성에 실패했습니다.") // 실패 메시지
                    }
                case .failure(let error):
                    self.showAlert(message: "에러 발생: \(error.localizedDescription)") // 에러 메시지
                }
            }
        }
    }



    
    
    // 알림 메서드
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func addPaddingToTextField(_ textField: UITextField, padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    

    
    // 뒤로가기 버튼 액션
    @objc private func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    // 완료 버튼 액션
    @objc private func handleCompleteButton() {
        handleCreateUser() // 회원 생성 로직 호출
    }
    
}

extension AdminUserCreateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Picker에 단일 열
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? departments.count : groups.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? departments[row] : groups[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            departmentIdTextField.text = departments[row]
        } else if pickerView.tag == 2 {
            groupTextField.text = groups[row]
        }
    }
}


#if DEBUG
import SwiftUI

struct AdminUserCreateViewControllerPreview: PreviewProvider {
    static var previews: some View {
        AdminUserCreateViewControllerRepresentable()
    }
}

struct AdminUserCreateViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AdminUserCreateViewController {
        return AdminUserCreateViewController()
    }
    
    func updateUIViewController(_ uiViewController: AdminUserCreateViewController, context: Context) {
        // 필요하면 업데이트 로직 추가
    }
}
#endif

