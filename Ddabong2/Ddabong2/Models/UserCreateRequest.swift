//
//  UserCreateRequest.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//


// UserCreateRequest.swift
import Foundation

struct UserCreateRequest: Encodable {
    let name: String
    let id: String
    let password: String
    let joinedAt: String
    let departmentId: Int
    let jobGroup: Int
    let group: String
}

// UserCreateResponse.swift
import Foundation

struct UserCreateResponse: Decodable {
    let status: String
    let message: String
}
