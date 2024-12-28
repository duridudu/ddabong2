//
//  ChatViewController+content.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//

import MessageKit
import InputBarAccessoryView

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return currentUser
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        print("MESSAGE 개수", messages.count)
        return messages.count
    }
}

extension ChatViewController: MessagesLayoutDelegate, MessagesDisplayDelegate {}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        sendMessage(text: text)
        inputBar.inputTextView.text = ""
    }
}
