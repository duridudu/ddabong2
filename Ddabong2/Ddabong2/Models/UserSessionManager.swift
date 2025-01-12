//JH
//토큰 관리!


class UserSessionManager {
    static let shared = UserSessionManager()

    private init() {}

    private var accessToken: String?
    private var refreshToken: String?

    func saveAccessToken(_ token: String) {
        accessToken = token
    }

    func saveRefreshToken(_ token: String) {
        refreshToken = token
    }

    func getAccessToken() -> String? {
        return accessToken
    }

    func getRefreshToken() -> String? {
        return refreshToken
    }
}
