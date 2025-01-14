//JH


import Foundation

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

struct UserResponse: Codable {
    let status: String
    let message: String
    let responseDto: User
}

struct UserListResponse: Codable {
    let status: String
    let message: String
    let responseDto: [User] // 여러 User 객체를 배열로 저장
}

