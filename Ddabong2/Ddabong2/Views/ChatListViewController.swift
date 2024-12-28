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
    var tableView: UITableView!
    var searchBar: UISearchBar!
    // var chatRooms: [String] = ["General Chat", "SwiftUI Tips", "Random Chat"]
    let viewModel = ChannelViewModel(currentUserId: "user1") // ViewModel 초기화
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 설정
        self.navigationItem.title = "채팅방"
            
         
        // 확인 버튼 설정
        let confirmButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(confirmButtonTapped))
            self.navigationItem.rightBarButtonItem = confirmButton
        
        
        // 커스텀 서치바 추가
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        
        // 서치바 위치 조정 (네비게이션 바 아래에 배치)
        let safeArea = self.view.safeAreaInsets.top
        searchBar.frame = CGRect(x: 10, y: safeArea + 90, width: self.view.frame.width - 20, height: 44)
        self.view.addSubview(searchBar)

            
        // 테이블뷰 설정
        tableView = UITableView()
        // 테이블 델리게이트 설정
        setupTableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false // 오토 레이아웃 사용
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatRoomCell")
        self.view.addSubview(tableView)

        // 오토 레이아웃으로 서치바와 테이블뷰 배치
        NSLayoutConstraint.activate([
            // 서치바
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),

            // 테이블뷰
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        
        
        // 채팅방 목록 가져오기
        viewModel.fetchChatRooms()
        
        // ViewModel의 데이터 업데이트 클로저 설정
        viewModel.onChatRoomsUpdated = { [weak self] chatRooms in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
      
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // "Main"은 스토리보드 파일 이름
        let particiVC = storyboard.instantiateViewController(withIdentifier: "particiVC")
      //  navigationController?.pushViewController(chatVC, animated: true)
        self.navigationController?.pushViewController(particiVC, animated: true)
    }
    
}

