import Alamofire
import Foundation
class UserService {
    static let shared = UserService()

    private init() {}

    // 회원 생성 메서드
    func createUser(user: UserCreateRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "https://myhands.store/user/join"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]
        
        // 회원 생성 API 요청
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode, statusCode == 201 {
                        completion(.success(true)) // 회원 생성 성공
                    } else {
                        completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "회원 생성 실패"])))
                    }
                case .failure(let error):
                    completion(.failure(error)) // 에러 처리
                }
            }
    }
}
