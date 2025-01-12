//
//  Board.swift
//  Ddabong2
//
//  Created by 안지희 on 1/7/25.

struct Board: Decodable, Hashable  {
    let boardId: Int
    let title: String
    let timeAgo: String
    let content: String // 필요하면 유지, 사용하지 않으면 제거
}

struct BoardResponse: Decodable {
    let status: String
    let message: String
    let responseDto: [Board]
}
