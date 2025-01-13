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
        button.setTitleColor(UIColor(red: 1.0, green: 91/255, blue: 53/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력해주세요."
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.borderStyle = .none
        return textField
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용을 입력해주세요."
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5.0
        return textView
    }()

    private let underlineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "underline"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()

    private let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()

    private let fileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.tintColor = .darkGray
        return button
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
        view.addSubview(contentTextView)
        view.addSubview(underlineButton)
        view.addSubview(photoButton)
        view.addSubview(fileButton)

        // Layout with AutoLayout
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        underlineButton.translatesAutoresizingMaskIntoConstraints = false
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        fileButton.translatesAutoresizingMaskIntoConstraints = false

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

            // Title TextField
            titleTextField.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),

            // Content TextView
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextView.heightAnchor.constraint(equalToConstant: 300),

            // Underline Button
            underlineButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            underlineButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            underlineButton.widthAnchor.constraint(equalToConstant: 40),
            underlineButton.heightAnchor.constraint(equalToConstant: 40),

            // Photo Button
            photoButton.leadingAnchor.constraint(equalTo: underlineButton.trailingAnchor, constant: 16),
            photoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            photoButton.widthAnchor.constraint(equalToConstant: 40),
            photoButton.heightAnchor.constraint(equalToConstant: 40),

            // File Button
            fileButton.leadingAnchor.constraint(equalTo: photoButton.trailingAnchor, constant: 16),
            fileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            fileButton.widthAnchor.constraint(equalToConstant: 40),
            fileButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
        underlineButton.addTarget(self, action: #selector(handleUnderlineButtonTapped), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(handlePhotoButtonTapped), for: .touchUpInside)
        fileButton.addTarget(self, action: #selector(handleFileButtonTapped), for: .touchUpInside)
        contentTextView.delegate = self
    }

    @objc private func handleBackButtonTapped() {
        // AdminMainViewController로 이동
        let adminMainVC = AdminMainViewController()
        adminMainVC.modalPresentationStyle = .fullScreen // 전체 화면 표시
        present(adminMainVC, animated: true, completion: nil)
    }


    @objc private func handleSaveButtonTapped() {
        print("완료 버튼 클릭")
    }

    @objc private func handleUnderlineButtonTapped() {
        print("밑줄 버튼 클릭")
    }

    @objc private func handlePhotoButtonTapped() {
        print("사진 버튼 클릭")
    }

    @objc private func handleFileButtonTapped() {
        print("파일 버튼 클릭")
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
