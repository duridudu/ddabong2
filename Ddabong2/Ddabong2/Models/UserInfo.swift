//
//  User.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/25/24.
//

import Foundation

struct User: Codable {
    let userId: Int
    let name: String
    let id: String
    let employeeNum: Int
    let joinedAt: String
    let department: String
    let avatarId: Int
    let level: String
}
struct UserResponse: Codable {
    let status: String
    let message: String
    let responseDto: User
}
