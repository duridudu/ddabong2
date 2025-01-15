import UIKit

class AdminBoardWriteViewController: UIViewController {

    // UI Elements
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글 작성"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private let saveButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("완료", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            button.backgroundColor = UIColor(red: 1.0, green: 91/255, blue: 53/255, alpha: 1.0)
            button.layer.cornerRadius = 16
            button.clipsToBounds = true
            return button
        }()


    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력해주세요."
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.borderStyle = .none
        return textField
    }()
    
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용을 입력해주세요."
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 0 // 테두리 제거
        textView.layer.borderColor = UIColor.clear.cgColor // 테두리 색상 제거
        textView.layer.cornerRadius = 0 // 모서리 둥글기도 제거 (필요 시)
        return textView
    }()


  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Add Subviews
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(saveButton)
        view.addSubview(titleTextField)
        view.addSubview(separatorView)
        view.addSubview(contentTextView)

        // Layout with AutoLayout
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Back Button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            // Title Label
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Save Button
            saveButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 80),
            saveButton.heightAnchor.constraint(equalToConstant: 40),

            // Title TextField
            titleTextField.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 32), // 간격 조정
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),

            // Separator View
            separatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            // Content TextView
            contentTextView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16), // 간격 조정
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16), // 화면 끝까지 맞춤
        ])
    }


    private func setupActions() {
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
        contentTextView.delegate = self
    }

    @objc private func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleSaveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "제목을 입력해주세요.")
            return
        }
        guard let content = contentTextView.text, !content.isEmpty, contentTextView.textColor != .lightGray else {
            showAlert(message: "내용을 입력해주세요.")
            return
        }

        // 게시글 생성 API 호출
        BoardService.shared.createBoard(title: title, content: content) { result in
            switch result {
            case .success:
                // 성공 시에는 바로 이전 화면으로 돌아감
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                // 실패 시에만 알림 모달 띄움
                DispatchQueue.main.async {
                    self.showAlert(message: "게시글 생성 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - UITextViewDelegate
extension AdminBoardWriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요."
            textView.textColor = .lightGray
        }
    }
}
