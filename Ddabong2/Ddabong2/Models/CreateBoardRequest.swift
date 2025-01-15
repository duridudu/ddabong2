//
//  CreateBoardRequest.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//


struct CreateBoardRequest: Encodable {
    let title: String
    let content: String
}

struct CreateBoardResponse: Decodable {
    let status: String
    let message: String
}
