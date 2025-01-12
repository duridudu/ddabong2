//JH
//토큰 관리!

import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()
    
    private init() {}
    
    private var accessToken: String?
    private var refreshToken: String?
    private var userInfo: User?
    
    func saveAccessToken(_ token: String) {
        self.accessToken = token
    }
    
    func saveRefreshToken(_ token: String) {
        self.refreshToken = token
    }
    
    func saveUserInfo(_ user: User) {
        self.userInfo = user
    }
    
    func getAccessToken() -> String? {
        return accessToken
    }
    
    func getUserInfo() -> User? {
        return userInfo
    }
}
