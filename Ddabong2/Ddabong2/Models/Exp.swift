//
//  Exp.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/15/25.
//

import Foundation

struct ExpResponse: Decodable {
    let quests: [Exp]
}

struct Exp: Decodable {
    let questId: Int
    let questType: String
    let name: String
    let grade: String
    let expAmount: Int
    let isCompleted: Bool
    let completedAt: String
    
    static let defaultExp = Exp(
            questId: 0,
            questType: "default",
            name: "No Data",
            grade: "NONE",
            expAmount: 0,
            isCompleted: false,
            completedAt: "N/A"
        )
    
}
