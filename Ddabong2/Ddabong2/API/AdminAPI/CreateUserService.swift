// CreateUserService.swift
import Alamofire

class CreateUserService {
    static let shared = CreateUserService()
    
    private init() {}

    func createUser(request: UserCreateRequest, completion: @escaping (Result<UserCreateResponse, Error>) -> Void) {
        let url = "https://myhands.store/user/join"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: UserCreateResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
