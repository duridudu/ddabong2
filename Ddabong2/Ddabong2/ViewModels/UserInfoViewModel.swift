import Foundation
import Alamofire

class LoginViewModel {
    var onLoginSuccess: ((Bool) -> Void)? // Admin 여부를 전달하기 위해 Bool 타입 추가
    var onLoginFailure: ((String) -> Void)?

    func login(id: String?, password: String?) {
        // 입력값 검증
        guard let id = id, !id.isEmpty,
              let password = password, !password.isEmpty else {
            self.onLoginFailure?("아이디 또는 비밀번호를 입력해주세요.")
            return
        }
        
        let url = "https://myhands.store/user/login"
        let parameters: [String: String] = ["id": id, "password": password]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    if loginResponse.status == "OK" {
                        let accessToken = loginResponse.responseDto.accessToken
                        let refreshToken = loginResponse.responseDto.refreshToken
                        let isAdmin = loginResponse.responseDto.admin // 어드민 여부 확인
                        
                        // 토큰 저장
                        UserSessionManager.shared.saveAccessToken(accessToken)
                        UserSessionManager.shared.saveRefreshToken(refreshToken)
                        
                        // 성공 콜백 호출 (isAdmin 전달)
                        self.onLoginSuccess?(isAdmin)
                    } else {
                        self.onLoginFailure?("아이디 또는 비밀번호를 확인해주세요.")
                    }
                case .failure:
                    self.onLoginFailure?("네트워크를 확인해주세요.")
                }
            }
    }
    
    // 푸시 토큰 처리
    private func fetchPushToken() {
        if let token = TokenManager.shared.getToken() {
            print("Using stored token: \(token)")
            // 서버에 푸시 토큰을 보낼 수 있음
        } else {
            print("No token found. It will be generated on the next startup.")
        }
    }
}
