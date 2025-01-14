//
//  AdminBoardService.swift
//  Ddabong2
//
//  Created by 안지희 on 1/13/25.
//

import Foundation
import Alamofire

class AdminBoardService {
    static let shared = AdminBoardService()

    private init() {}

    func createPost(title: String, content: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://myhands.store/board/create"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]
        let parameters: [String: Any] = [
            "title": title,
            "content": content
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let responseDict = value as? [String: Any],
                       let status = responseDict["status"] as? String, status == "CREATED" {
                        completion(.success(()))
                    } else {
                        let error = NSError(domain: "", code: 3001, userInfo: [NSLocalizedDescriptionKey: "게시글 생성에 실패했습니다."])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
