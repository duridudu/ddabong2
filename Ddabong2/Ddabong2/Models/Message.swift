//
//  Message.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//

import Foundation
import MessageKit
import UIKit

struct Message: MessageType {
    var sender: SenderType
      var messageId: String
      var sentDate: Date
      var kind: MessageKind
  
    
}

//extension Message: Comparable {
//    static func == (lhs: Message, rhs: Message) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    static func < (lhs: Message, rhs: Message) -> Bool {
//        return lhs.sentDate < rhs.sentDate
//    }
//}
