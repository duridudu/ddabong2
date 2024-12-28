//
//  Channel.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//

import Foundation
struct Channel {
    let id: String
    let name: String
    let lastMessage: String
    let timestamp: Date
    let members: [String]   // 멤버 ID 배열
//    init(id: String? = nil, name: String) {
//        self.id = id
//        self.name = name
//    }
}
//
//extension Channel: Comparable {
//    static func == (lhs: Channel, rhs: Channel) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    static func < (lhs: Channel, rhs: Channel) -> Bool {
//        return lhs.name < rhs.name
//    }
//}
