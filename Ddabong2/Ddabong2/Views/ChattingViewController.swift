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

class ChattingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var tableView: UITableView!
    var searchBar: UISearchBar!
    // var chatRooms: [String] = ["General Chat", "SwiftUI Tips", "Random Chat"]
    
    @IBOutlet weak var chatList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Navigation Controller: \(self.navigationController)")
        // 네비게이션 타이틀 설정
      //  self.title = "채팅 목록"
        
        // 검색 바 설정
        //setupSearchBar()
        
        // 테이블 뷰 설정
        setupTableView()
        
        // 채팅 추가 버튼 설정
//        setupAddButton()
        
    fetchChatRooms()
    }
    
    
    var chatRooms: [Channel] = []
    let db = Firestore.firestore()
    
    // 검색 바 설정
//    func setupSearchBar() {
//        searchBar = UISearchBar()
//        searchBar.delegate = self
//        searchBar.placeholder = "채팅방 검색"
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar)
//        
//        // 검색 바 제약조건 설정
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//    }
    
    
    // 테이블 뷰 설정
    func setupTableView() {
       // tableView = chatList
        chatList.dataSource = self
        chatList.delegate = self
        chatList.translatesAutoresizingMaskIntoConstraints = false
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatRoomCell")
      //  view.addSubview(tableView)
        
        // 테이블 뷰 제약조건 설정
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
    }
        
        // 채팅 추가 버튼 설정
        func setupAddButton() {
            let addButton = UIButton(type: .system)
            addButton.setTitle("채팅 추가", for: .normal)
            //addButton.addTarget(self, action: #selector(addChatRoom), for: .touchUpInside)
            addButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(addButton)
            
            // 버튼 제약조건 설정
            NSLayoutConstraint.activate([
                addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        
        // 채팅 추가 버튼 눌렀을 때 액션
        //              @objc func addChatRoom() {
        //                  // 채팅 추가 로직
        //                  print("채팅 추가 버튼 눌림")
        //              }
        
        func fetchChatRooms() {
            db.collection("chatrooms").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching chat rooms: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.chatRooms = documents.map { doc in
                    let data = doc.data()
                    return Channel(
                        id: doc.documentID,
                        name: data["chatroomName"] as? String ?? "Unknown",
                        lastMessage: data["lastMessage"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        members:data["members"] as? [String] ?? [] // 멤버 배열 읽기
            
                    )
                }
                self.chatList.reloadData()
            }
        }
    }

