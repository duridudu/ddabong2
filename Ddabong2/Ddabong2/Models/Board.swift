//
//  Board.swift
//  Ddabong2
//
//  Created by 안지희 on 1/7/25.
//


import Foundation

struct Board: Decodable {
    let boardId: Int
    let title: String
    let createdAt: String
}

struct BoardResponse: Decodable {
    let status: String
    let message: String
    let responseDto: BoardResponseDto
}

struct BoardResponseDto: Decodable {
    let boardList: [Board]
}
