//
//  ChattingViewController+list.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//

import UIKit

// 채팅방 리스트 테이블뷰셀
extension ChattingViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatroom", for: indexPath)
        let chatRoom = chatRooms[indexPath.row]
        cell.textLabel?.text = chatRoom.name
        cell.detailTextLabel?.text = chatRoom.lastMessage
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoom = chatRooms[indexPath.row]
        let chatVC = ChatViewController(chatRoomId: chatRoom.id)
        print("클릭됨------", chatRoom.id)
        print(navigationController)
      //  navigationController?.pushViewController(chatVC, animated: true)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
