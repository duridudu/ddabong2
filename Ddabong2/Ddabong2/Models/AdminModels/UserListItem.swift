//
//  UserListItem.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//


struct AdminUserListResponse: Decodable {
    let status: String
    let message: String
    let responseDto: [UserListItem]
}

struct UserListItem: Decodable {
    let userId: Int
    let name: String
    let employeeNum: Int
    let department: String
    let avartaId: Int
    let level: String
}
