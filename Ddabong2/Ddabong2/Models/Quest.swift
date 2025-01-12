//
//  Quest.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/11/25.
//

import Foundation

struct QuestResponseDTO: Decodable {
    let weekCount: Int
    let questList: [[Quest]]
}

struct Quest: Decodable {
    let questId: Int
    let questType: String
    let name: String
    let grade: String
    let expAmount: Int
    let isCompleted: Bool
    let completedAt: String
    let imageUrl: String? // 이미지 URL 추가 (Optional)
}
