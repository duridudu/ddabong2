//
//  APIResponse.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/1/25.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let status: String
    let code: Int?
    let message: String
    let responseDto: T?
}
