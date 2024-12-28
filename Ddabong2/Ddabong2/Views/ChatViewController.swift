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
    let chatRoomId: String
    var messages: [Message] = []
    let db = Firestore.firestore()
    let currentUser = Sender(senderId: "user2", displayName: "따봉2") // 현재 유저 정보
    
    init(chatRoomId: String) {
        self.chatRoomId = chatRoomId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        fetchChatData()
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
