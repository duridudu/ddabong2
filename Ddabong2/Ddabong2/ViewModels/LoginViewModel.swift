import Foundation
import Alamofire

class LoginViewModel {
    
    // 로그인 성공과 실패 시 처리할 클로저
    var onLoginSuccess: ((User) -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    // 로그인 요청을 보내는 함수
    func loginUser(email: String, password: String) {
        let loginURL = "https://myhands.store/user/login"  // 서버 로그인 URL
        
        // 요청할 파라미터
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        // Alamofire로 API 요청
        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let loginResponse):
                if loginResponse.status == "OK" {
                    let user = User(
                        accessToken: loginResponse.responseDto.accessToken,
                        name: loginResponse.responseDto.name,
                        email: loginResponse.responseDto.email,
                        photo: loginResponse.responseDto.photo,
                        dayOffCnt: loginResponse.responseDto.dayOffCnt,
                        employeeNum: loginResponse.responseDto.employeeNum,
                        role: loginResponse.responseDto.role
                    )
                    self.onLoginSuccess?(user)
                } else {
                    self.onLoginFailure?(loginResponse.message)
                }
            case .failure(let error):
                self.onLoginFailure?(error.localizedDescription)
            }
        }
    }
}
