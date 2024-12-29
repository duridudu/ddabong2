//
//  ChattingViewController+list.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//

import UIKit

// 채팅방 리스트 테이블뷰셀
extension ChatListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("+++챗룸개수+++",viewModel.chatRooms.count)
        return viewModel.chatRooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        let chatRoom = viewModel.chatRooms[indexPath.row]
        cell.textLabel?.text = chatRoom.chatroomName
        cell.detailTextLabel?.text = chatRoom.lastMessage
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoom = viewModel.chatRooms[indexPath.row]
        if let chatVC = storyboard?.instantiateViewController(withIdentifier: "parentVC") as? ChatParentViewController {
            print("ChatParentViewController instance: \(chatVC)")
            chatVC.chatroomId = chatRoom.id // 프로퍼티 설정
            navigationController?.pushViewController(chatVC, animated: true)
        }


    }
}
