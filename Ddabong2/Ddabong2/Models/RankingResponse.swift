//
//  RankingResponse.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//


struct RankingResponse: Decodable {
    let status: String
    let message: String
    let responseDto: RankingResponseDto
}

struct RankingResponseDto: Decodable {
    let myIndex: Int
    let needExp: Int
    let rankList: [Rank]
}

struct Rank: Decodable {
    let departmentId: Int
    let expAvg: Int
    let rank: Int
}
