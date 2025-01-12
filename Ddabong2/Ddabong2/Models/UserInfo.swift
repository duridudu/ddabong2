//
//  User.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/25/24.
//

import Foundation

struct UserResponse: Codable {
    let status: String
    let message: String
    let responseDto: User
}

struct User: Codable {
    let userId: Int
    let name: String
    let id: String
    let password: String
    let employeeNum: Int
    let joinedAt: String
    let department: String
    let avartaId: Int
    let level: String
}
