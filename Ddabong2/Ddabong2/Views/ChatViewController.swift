//
//  ChatViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatViewController: MessagesViewController {
    
    var chatRoomId: String = ""
    var messages: [Message] = []
    let db = Firestore.firestore()
    let currentUser = Sender(senderId: "user2", displayName: "따봉2") // 현재 유저 정보
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ROOM ID --- ", chatRoomId)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        // inputBar의 배경색 변경
        // inputBar가 정상적으로 보이도록 설정
           messageInputBar.alpha = 1
           messageInputBar.isHidden = false
        // inputBar 크기와 위치 설정
//        messageInputBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)  // 적당한 높이로 설정
//        self.view.addSubview(messageInputBar)
//        print("messageInputBar", messageInputBar)
        messageInputBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageInputBar)

        // 오토 레이아웃으로 크기 및 위치 설정
        NSLayoutConstraint.activate([
            messageInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageInputBar.heightAnchor.constraint(equalToConstant: 44)  // 높이를 설정
        ])
        
        fetchChatData()
        
      
        
    }
    
    
    // 뒤로 가기 버튼 액션
    @objc func backButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // "Main"은 스토리보드 파일 이름
        let chatListVC = storyboard.instantiateViewController(withIdentifier: "chatListVC")
        // 네비게이션 스택을 초기화하고 새로운 뷰 컨트롤러를 루트로 설정
        // 기존 뷰 컨트롤러들을 모두 제거하고 새로운 뷰 컨트롤러만 네비게이션 스택에 추가
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
                
    }

    // 확인 버튼 액션
    @objc func confirmButtonTapped() {
        // 새 채팅방 저장
        
        // 해당 채팅방 id 가져와서 네비게이션뷰에 push
//        let chatVC = ChatViewController(chatRoomId: "tFOnTDw8ZyAQhsqJRclw")
//        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
   
    func fetchChatData() {
            db.collection("chatrooms")
                .document(chatRoomId)
                .collection("chatData")
                .order(by: "createdAt", descending: false) // 시간 순서로 정렬
                .addSnapshotListener { [weak self] snapshot, error in
                    guard let self = self, let snapshot = snapshot else { return }
                    
                    self.messages = snapshot.documents.compactMap { doc in
                        let data = doc.data()
                        
                        // 필드값 확인 및 기본값 제공
                        let senderId = data["senderId"] as? String ?? "Unknown"
                        let senderName = data["senderName"] as? String ?? "Unknown"
                        let content = data["content"] as? String ?? "No content"
                        let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        
                        // Sender 및 Message 인스턴스 생성
                        let sender = Sender(senderId: senderId, displayName: senderName)
                        return Message(
                            sender: sender,
                            messageId: doc.documentID,
                            sentDate: timestamp,
                            kind: .text(content)
                        )
                    }
                    
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
                }
        }
        
  func sendMessage(text: String) {
    let message = [
        //            "senderId": currentUser.senderId,
        //            "displayName": currentUser.displayName,
        "senderId": "user2",
        "senderName": "따봉2",
        "content": text,
        "createdAt": FieldValue.serverTimestamp()
    ] as [String: Any]
    
    db.collection("chatrooms").document(chatRoomId).collection("chatData").addDocument(data: message)
      // 채팅 리스트의 마지막 메세지도 바꿔줘야함
      db.collection("chatrooms").document(chatRoomId).updateData([
              "lastMessage": text
          ]) { error in
              if let error = error {
                  print("Error updating lastMessage: \(error.localizedDescription)")
              } else {
                  print("LastMessage successfully updated!")
              }
          }
  }
}
