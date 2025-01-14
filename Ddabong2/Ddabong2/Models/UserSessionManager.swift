import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()
    
    private init() {}
    
    private var accessToken: String?
    private var refreshToken: String?
    private var userInfo: User?
    private var isAdmin: Bool = false // admin 여부 저장
    
    func saveAccessToken(_ token: String) {
        self.accessToken = token
    }
    
    func saveRefreshToken(_ token: String) {
        self.refreshToken = token
    }
    
    func saveUserInfo(_ user: User) {
        self.userInfo = user
    }
    
    func saveAdminStatus(_ admin: Bool) {
        self.isAdmin = admin
    }
    
    func getAccessToken() -> String? {
        return accessToken
    }
    
    func getUserInfo() -> User? {
        return userInfo
    }
    
    func isAdminUser() -> Bool {
        return isAdmin
    }
}
