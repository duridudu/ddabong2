//
//  LoginResponse.swift
//  Ddabong2
//
//  Created by 안지희 on 1/4/25.
//

struct LoginResponse: Codable {
    let status: String
    let message: String
    let responseDto: LoginResponseDto
}

struct LoginResponseDto: Codable {
    let accessToken: String
    let refreshToken: String
    let admin: Bool
}

