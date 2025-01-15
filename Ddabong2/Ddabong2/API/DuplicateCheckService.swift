import Foundation
import Alamofire

class DuplicateCheckService {
    static let shared = DuplicateCheckService() // 싱글톤 패턴

    private init() {}

    func checkDuplicate(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard !id.isEmpty else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "아이디를 입력해주세요."])))
            return
        }

        let url = "https://myhands.store/user/duplicate"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(TokenManager.shared.getToken() ?? "")"
        ]
        let parameters: [String: String] = ["id": id] // 파라미터 정의

        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300) // 성공 응답 코드 검증
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any],
                       let status = json["status"] as? String,
                       let message = json["message"] as? String {
                        if status == "OK" && message == "ID is available" {
                            completion(.success(true)) // 사용 가능한 ID
                        } else if status == "BAD_REQUEST" && message == "ID is already in use" {
                            completion(.success(false)) // 중복된 ID
                        } else {
                            completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "알 수 없는 응답입니다."])))
                        }
                    } else {
                        completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "응답 데이터 형식 오류"])))
                    }
                case .failure(let error):
                    completion(.failure(error)) // 네트워크 오류
                }
            }
    }
}
