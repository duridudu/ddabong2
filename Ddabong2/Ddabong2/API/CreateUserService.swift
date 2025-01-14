//
//  CreateUserService.swift
//  Ddabong2
//
//  Created by 안지희 on 1/14/25.
//

import Foundation
import Alamofire

class CreateUserService {
    static let shared = CreateUserService()
    
    private init() {}
    
    func createUser(parameters: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://myhands.store/user/join"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ApiResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    if apiResponse.status == "CREATED" {
                        completion(.success(apiResponse.message))
                    } else {
                        completion(.failure(NSError(domain: "", code: apiResponse.code ?? 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

// API 응답 모델
struct ApiResponse: Decodable {
    let status: String
    let code: Int?
    let message: String
}
