//
//  ProfileService.swift
//  Ddabong2
//
//  Created by 안지희 on 1/13/25.
//


import Alamofire

class ProfileService {
    static let shared = ProfileService() // 싱글톤 인스턴스

    private init() {}

    func updateProfileImage(avatarId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://myhands.store/user/image"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]
        let parameters: [String: Any] = ["avartaId": avatarId]

        AF.request(url, method: .patch, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
