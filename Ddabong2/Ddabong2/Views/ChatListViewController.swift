//
//  ChattingViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/25/24.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView
import UIKit
import FirebaseFirestore

class ChatListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var chatList: UITableView!
    
    let viewModel = ChannelViewModel(currentUserId: "user1") // ViewModel 초기화
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // 채팅방 목록 가져오기
        viewModel.fetchChatRooms()
        
        // ViewModel의 데이터 업데이트 클로저 설정
        viewModel.onChatRoomsUpdated = { [weak self] chatRooms in
            print("Chat rooms updated: \(chatRooms.count)")  // 클로저가 호출되는지 확인
            DispatchQueue.main.async {
                self?.chatList.reloadData()
            }
        }
        
    }
    
 

    // 확인 버튼 액션
    @objc func confirmButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // "Main"은 스토리보드 파일 이름
        let particiVC = storyboard.instantiateViewController(withIdentifier: "particiVC")
      //  navigationController?.pushViewController(chatVC, animated: true)
        self.navigationController?.pushViewController(particiVC, animated: true)
    }
    
    // 테이블 뷰 설정
    func setupTableView() {
       // tableView = chatList
        chatList.dataSource = self
        chatList.delegate = self
     //   chatList.translatesAutoresizingMaskIntoConstraints = false
      
    }
  
    
    @IBAction func btnAdd(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // "Main"은 스토리보드 파일 이름
        let particiVC = storyboard.instantiateViewController(withIdentifier: "particiVC")
      //  navigationController?.pushViewController(chatVC, animated: true)
        self.navigationController?.pushViewController(particiVC, animated: true)
    }
    
}

