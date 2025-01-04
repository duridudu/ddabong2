//
//  LoginResponse.swift
//  Ddabong2
//
//  Created by 안지희 on 1/4/25.
//

import Foundation

// 로그인 응답을 처리하는 모델
struct LoginResponse: Decodable {
    let status: String
    let message: String
    let responseDto: ResponseDto
}

// 로그인 성공 시 반환되는 세부 사용자 정보
struct ResponseDto: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let name: String
    let email: String?
    let photo: String
    let role: String?
    let dayOffCnt: Float?
    let employeeNum: Int
    let department: String
}
