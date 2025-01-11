import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()
    
    private init() {}
    
    var accessToken: String?
    var refreshToken: String?

    func saveAccessToken(_ token: String) {
        self.accessToken = token
    }
    
    func saveRefreshToken(_ token: String) {
        self.refreshToken = token
    }
}
