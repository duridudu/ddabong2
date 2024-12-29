//
//  Partici+extension.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/29/24.
//

import Foundation
import UIKit
// 채팅방 리스트 테이블뷰셀

extension ParticiViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParticiCell", for: indexPath) as! ParticiCell
        
//        let chatRoom = viewModel.chatRooms[indexPath.row]
        //cell.textLabel?.text = ""
        cell.textLabel?.text = "김땡떙 [IT개발부/대리]"
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        /let chatRoom = viewModel.chatRooms[indexPath.row]
//        let chatVC = ChatViewController(chatRoomId: chatRoom.id)
//      //  navigationController?.pushViewController(chatVC, animated: true)
//        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
