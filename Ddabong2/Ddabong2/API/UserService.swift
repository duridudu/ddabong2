//
//  UserService.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/1/25.
//

import Alamofire
import Foundation

// user 관련 API 호출 세팅
class UserService {
   
    struct Empty: Decodable {}
    
    func loginUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = Endpoints.User.login.replacingOccurrences(of: "{id}", with: id)
        
        let parameters: [String: Any] = [
            "email": "john@example.com",
            "password": "securePassword123"
        ]
        
        AlamofireManager.shared.request(
            url: url,
            method: .post,
            parameters: parameters,
            headers: nil,
            // 호출할때 responseType 지정해서 responseDto 바로 받음
            responseType: User.self)
            { result in
                switch result {
                case .success(let responseDto):
                    // 공통 함수에서 가져온 responseDto(User) 정보 반환
                    print("Login Success: \(responseDto)") // 바로 사용
                    completion(.success(responseDto)) // 성공적으로 로그인한 사용자 정보 반환->뷰컨트롤러에서 사용
                case .failure(let error):
                    // 실패 시 에러 처리
                    print("Login Failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    
    }
    
   
}
