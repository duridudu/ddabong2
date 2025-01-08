//
//  NavigationBarViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/8/25.
//

import Foundation
import UIKit

class CustomNavigationBar: UIView {
    
    // 버튼들
    private let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("홈", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(nil, action: #selector(didTapHomeButton), for: .touchUpInside)
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .orange
        button.addTarget(nil, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 4
        
        // 버튼 추가
        addSubview(homeButton)
        addSubview(addButton)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 레이아웃 설정
        NSLayoutConstraint.activate([
            homeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            homeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // 버튼 액션 - 상속받은 뷰 컨트롤러에서 오버라이드 가능
    @objc func didTapHomeButton() {
        print("홈 버튼 클릭됨")
    }
    
    @objc func didTapAddButton() {
        print("추가 버튼 클릭됨")
    }
}

import SwiftUI

struct NCustomNavigationBarPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let navigationBarVC = CustomNavigationBar()
            return navigationBarVC
        }
    }
}


