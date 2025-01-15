//
//  Department.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//

// 유저 생성할때... 써야하는 파일


import Foundation
import UIKit

enum Department: Int, CaseIterable {
    case 음성1센터 = 1
    case 음성2센터 = 2
    case 용인백암센터 = 3
    case 남양주센터 = 4
    case 파주센터 = 5
    case 사업기획팀 = 6
    case 그로스팀 = 7
    case CX팀 = 8
    
    var displayName: String {
        switch self {
        case .음성1센터: return "음성 1센터"
        case .음성2센터: return "음성 2센터"
        case .용인백암센터: return "용인백암센터"
        case .남양주센터: return "남양주센터"
        case .파주센터: return "파주센터"
        case .사업기획팀: return "사업기획팀"
        case .그로스팀: return "그로스팀"
        case .CX팀: return "CX팀"
        }
    }
}

enum Group: String, CaseIterable {
    case F = "F 현장 직군"
    case B = "B 관리 직군"
    case G = "G 성장 전략"
    case T = "T 기술 직군"
    
    var displayName: String {
        return self.rawValue
    }
}
