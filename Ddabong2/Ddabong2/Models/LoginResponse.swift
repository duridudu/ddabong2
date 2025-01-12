//
//  LoginResponse.swift
//  Ddabong2
//
//  Created by 안지희 on 1/4/25.
//
//건들지마시오 수정할것이없소 나자신아
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

