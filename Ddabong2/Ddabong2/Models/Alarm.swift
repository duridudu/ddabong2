//
//  Alarm.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/15/25.
//


import Foundation

// 개별 알람 항목
struct Alarm: Decodable {
    var category: Bool
    var createdAt: String
    var title: String
    var boardId: Int?
    var exp: Int
}

// 전체 응답 구조체
struct AlarmResponse: Decodable {
    var recentAlarmList: [Alarm]
    var oldAlarmList: [Alarm]
}

