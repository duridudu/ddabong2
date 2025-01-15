//
//  UserCreateRequest.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//


// UserCreateRequest.swift
import Foundation

struct UserCreateRequest: Codable {
    var name: String
    var id: String
    var password: String
    var joinedAt: String
    var departmentId: Int
    var jobGroup: Int
    var group: String
}

// UserCreateResponse.swift
import Foundation

struct UserCreateResponse: Decodable {
    let status: String
    let message: String
}
