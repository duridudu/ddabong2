//
//  ChatParentViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/29/24.
//

import Foundation
import MessageKit
import InputBarAccessoryView
import UIKit
class ChatParentViewController:UIViewController {
  
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    // Chat Room ID를 저장할 프로퍼티
    var chatroomId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CHAT ROOM : ", self.chatroomId)
        // 대신 자식 뷰 컨트롤러를 명시적으로 추가
          let chatVC = ChatViewController()
        chatVC.chatRoomId = self.chatroomId ?? "" // 자식에게 roomId 전달
          addChild(chatVC)
          
          // 컨테이너 뷰에 자식 뷰 컨트롤러의 뷰를 추가
          chatVC.view.frame = containerView.bounds
          containerView.addSubview(chatVC.view)
          chatVC.didMove(toParent: self)
       
        
    }
        
   
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    }
    

