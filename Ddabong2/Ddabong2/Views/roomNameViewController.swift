//
//  roomNameViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//

import Foundation
import UIKit
class roomNameViewController:UIViewController{
    let viewModel = ChannelViewModel(currentUserId: "user1") // ViewModel 초기화
    
    // 앞 화면에서 선택한 members 저장할 배열 필요
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnOk(_ sender: Any) {
        // 새 채팅방 저장
        
        // 해당 채팅방 id 가져와서 네비게이션뷰에 push
        viewModel.createChatRoom(chatroomName: "테스트 채팅방", chatMembers: ["user1", "user2"]) { documentId in
            if let chatId = documentId {
                print("생성된 채팅방 ID: \(chatId)")
                if let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "parentVC") as? ChatParentViewController {
                    print("ChatParentViewController instance: \(chatVC)")
                    chatVC.chatroomId = chatId // 프로퍼티 설정
                    self.navigationController?.pushViewController(chatVC, animated: true)
                }
                
            } else {
                print("채팅방 생성 실패")
            }
        }
        
        

    }
    
}
