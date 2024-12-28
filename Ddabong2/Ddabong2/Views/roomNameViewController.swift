//
//  roomNameViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//

import Foundation
import UIKit
class roomNameViewController:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 설정
        self.navigationItem.title = "채팅방 이름"
        
        // 뒤로가기 버튼 설정
        let backButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = backButton
        
       // 확인 버튼 설정
       let confirmButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(confirmButtonTapped))
           self.navigationItem.rightBarButtonItem = confirmButton
        
    }
    
    
    // 뒤로 가기 버튼 액션
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    // 확인 버튼 액션
    @objc func confirmButtonTapped() {
        // 새 채팅방 저장
        
        // 해당 채팅방 id 가져와서 네비게이션뷰에 push
        let chatVC = ChatViewController(chatRoomId: "tFOnTDw8ZyAQhsqJRclw")
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        // 새 채팅방 저장
        
        // 해당 채팅방 id 가져와서 네비게이션뷰에 push
        let chatVC = ChatViewController(chatRoomId: "tFOnTDw8ZyAQhsqJRclw")
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
