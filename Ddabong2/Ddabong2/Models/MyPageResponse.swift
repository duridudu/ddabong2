//
//  MyPageResponse.swift
//  Ddabong2
//
//  Created by 안지희 on 1/13/25.
//


import Foundation

struct MyPageResponse: Codable {
    let status: String
    let message: String
    let responseDto: MyPageResponseDto
}

struct MyPageResponseDto: Codable {
    let fortune: Fortune
    let levelRate: LevelRate
    let recentExp: RecentExp
    let thisYearExp: ExpDetails
    let lastYearExp: ExpDetails
}

struct Fortune: Codable {
    let date: String
    let contents: String
}

struct LevelRate: Codable {
    let currentLevel: String
    let currentExp: Int
    let nextLevel: String
    let leftExp: Int
    let percent: Int
}

struct RecentExp: Codable {
    let questId: Int
    let questType: String
    let name: String
    let grade: String
    let expAmount: Int
    let isCompleted: Bool
    let completedAt: String
}

struct ExpDetails: Codable {
    let expAmount: Int
    let percent: Int
}
