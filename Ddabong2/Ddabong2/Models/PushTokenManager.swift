//
//  PushTokenManager.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/10/25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let tokenKey = "FCMTokenKey"

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
}
