//JH


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
