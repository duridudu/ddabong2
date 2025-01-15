//
//  ExpViewModel.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/15/25.
//


import Foundation
import Alamofire

class ExpViewModel{
    var responseDto: ExpResponse? {
        didSet {
            onResponseDtoUpdated?(responseDto)
        }
    }
    var onResponseDtoUpdated: ((ExpResponse?) -> Void)?
    
    func fetchAllExps(page: Int, size: Int, completion: (() -> Void)? = nil) {
        print("API 호출 시작 - fetchAllExps")
        let url = "https://myhands.store/quest/completelist"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "토큰 없음")"
        ]
        
        let parameters: [String: Any] = [
            "page": page,
            "size": size
        ]
        
        print("요청 URL: \(url)")
        print("요청 헤더: \(headers)")
        print("요청 파라미터: \(parameters)")
        
        AF.request(url, method: .get,
                   parameters: parameters, headers: headers)
        .responseDecodable(of: APIResponse<ExpResponse>.self) { response in
            switch response.result {
            case .success(let data):
                // 성공적으로 디코딩한 데이터 사용
                print("Status: \(data.status)")
                print("Message: \(data.message)")
                self.responseDto = data.responseDto
            case .failure(let error):
                // 오류 처리
                print("Error: \(error)")
            }
            completion?() // 데이터 처리 후 완료 콜백 호출
        }
    }
    
    
}
