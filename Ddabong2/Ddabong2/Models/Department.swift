//
//  Department.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//

// 유저 생성할때... 써야하는 파일


enum Department: String {
    case eumseong1 = "음성 1센터"
    case eumseong2 = "음성 2센터"
    case yonginBaekam = "용인백암센터"
    case namyangju = "남양주센터"
    case paju = "파주센터"
    case businessPlanning = "사업기획팀"
    case growthTeam = "그로스팀"
    case cxTeam = "CX팀"

    var id: Int {
        switch self {
        case .eumseong1: return 1
        case .eumseong2: return 2
        case .yonginBaekam: return 3
        case .namyangju: return 4
        case .paju: return 5
        case .businessPlanning: return 6
        case .growthTeam: return 7
        case .cxTeam: return 8
        }
    }

    static func from(_ string: String) -> Department? {
        return Department(rawValue: string)
    }
}

enum Group: String {
    case field = "F 현장 직군"
    case management = "B 관리 직군"
    case growth = "G 성장 전략"
    case technical = "T 기술 직군"

    var code: String {
        switch self {
        case .field: return "F"
        case .management: return "B"
        case .growth: return "G"
        case .technical: return "T"
        }
    }

    static func from(_ string: String) -> Group? {
        return Group(rawValue: string)
    }
}
