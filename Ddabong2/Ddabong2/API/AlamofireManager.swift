//
//  AlamofireManager.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/1/25.
//

import Foundation
import Alamofire

class AlamofireManager {
    static let shared = AlamofireManager()
    
    private init() {}
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 요청 타임아웃 설정
        configuration.timeoutIntervalForResource = 30
        return Session(configuration: configuration)
    }()
    
    // 공통으로 사용하는 request 함수
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        responseType:T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate() // HTTP 상태 코드 검증
            .responseDecodable(
                of: APIResponse<T>.self // 우리가 사용하는 response 요소들
            ) { response in
                switch response.result {
                // 성공하면 request와 맞는 구조체 반환 (User api이면 이 apiResponse는 User)
                case .success(let apiResponse):
                    if  apiResponse.status == "success" {
                        // responseDto가 옵셔널이라면 안전하게 언래핑
                        // 공통 함수에서는 responseDto만 잘 빼서 각 호출함수로 넘긴다.
                        if let responseDto = apiResponse.responseDto {
                            print("Received Response DTO: \(responseDto)")
                        } else {
                            print("No response DTO available")
                        }
                    }
                    else {
                        // 실패 메시지 반환
                        completion(.failure(apiResponse.message as! Error))
                    }
                case .failure(let error):
                    // 네트워크 에러 메시지 반환
                    completion(.failure(error.localizedDescription as! Error))
                }
            }
    }
    
}
