//
//  ProfileChangeModalViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/14/25.
//


import UIKit

class ProfileChangeModalViewController: UIViewController {
    var onConfirm: (() -> Void)? // 확인 버튼 콜백

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // 배경 설정
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // 모달 뷰
        let modalView = UIView()
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 20
        view.addSubview(modalView)
        modalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.widthAnchor.constraint(equalToConstant: 300),
            modalView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // 아이콘
        let iconImageView = UIImageView(image: UIImage(named: "changemodal")) // 프로필 변경 아이콘
        iconImageView.contentMode = .scaleAspectFit
        modalView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 메시지 레이블
        let messageLabel = UILabel()
        messageLabel.text = "프로필 변경 완료"
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 21) // Bold 처리 및 폰트 크기 21
        messageLabel.textColor = .black
        modalView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor)
        ])
        
        // 버튼 스택뷰
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        modalView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 취소 버튼
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .lightGray
        cancelButton.layer.cornerRadius = 5
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // Bold 처리
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        stackView.addArrangedSubview(cancelButton)
        
        // 확인 버튼
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = UIColor(red: 66/255, green: 195/255, blue: 116/255, alpha: 1.0) // 초록색 42C374
        confirmButton.layer.cornerRadius = 5
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // Bold 처리
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        stackView.addArrangedSubview(confirmButton)
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleConfirm() {
        dismiss(animated: true) {
            self.onConfirm?() // 확인 콜백 호출
        }
    }
}
