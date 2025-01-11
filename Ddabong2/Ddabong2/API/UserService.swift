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
            "id": "john",
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
    
    func fetchUserInfo(accessToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        // URL 설정
        let url = "https://myhands.store/user/info" // 직접 URL 입력
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"] // 인증 헤더
        
        // Alamofire 요청
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userResponse):
                    let userInfo = userResponse.responseDto // 응답 데이터에서 유저 정보 추출
                    print("유저 정보 가져오기 성공: \(userInfo)")
                    completion(.success(userInfo)) // 성공 콜백 호출
                case .failure(let error):
                    print("유저 정보 가져오기 실패: \(error.localizedDescription)")
                    completion(.failure(error)) // 실패 콜백 호출
                }
            }
    }
}
