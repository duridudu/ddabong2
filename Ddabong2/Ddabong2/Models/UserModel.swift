//
//  User.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/25/24.
//

import Foundation
struct User :Decodable {
    let accessToken:String
    let name: String
    let email: String?
    let photo:String
    let dayOffCnt: Float?
    let employeeNum: Int
    let role: String?
    
}
