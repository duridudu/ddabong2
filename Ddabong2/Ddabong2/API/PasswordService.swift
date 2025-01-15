import Alamofire

class PasswordService {
    static let shared = PasswordService()

    private init() {}

    func changePassword(newPassword: String, completion: @escaping (Bool, String?) -> Void) {
        // 액세스 토큰 확인
        guard let token = UserSessionManager.shared.getAccessToken() else {
            completion(false, "User is not authenticated.")
            return
        }

        // API 요청 URL 및 헤더
        let url = "https://myhands.store/user/password"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]

        // 요청 Body 생성
        let body = ChangePasswordRequest(password: newPassword)

        // API 요청
        AF.request(url, method: .patch, parameters: body, encoder: JSONParameterEncoder.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        completion(true, nil) // 성공 시
                    } else {
                        let errorMessage = "Password change failed with status code: \(response.response?.statusCode ?? -1)."
                        completion(false, errorMessage) // 실패 메시지
                    }
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
    }
}

