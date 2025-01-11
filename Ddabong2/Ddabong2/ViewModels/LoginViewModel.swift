import Alamofire

class LoginViewModel {
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    func login(id: String, password: String) {
        let url = "https://myhands.store/user/login"
        let parameters: [String: String] = ["id": id, "password": password]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    if loginResponse.status == "OK" {
                        let accessToken = loginResponse.responseDto.accessToken
                        let refreshToken = loginResponse.responseDto.refreshToken
                        
                        // AccessToken 저장
                        UserSessionManager.shared.saveAccessToken(accessToken)
                        
                        // RefreshToken 저장 (필요한 경우)
                        UserSessionManager.shared.saveRefreshToken(refreshToken)
                        
                        // 성공 콜백 호출
                        self.onLoginSuccess?()
                    } else {
                        self.onLoginFailure?("로그인 실패:")
                    }
                case .failure(let error):
                    self.onLoginFailure?("네트워크 에러:")
                }
            }
    }
}
