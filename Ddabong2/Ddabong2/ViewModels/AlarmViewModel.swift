//
//  AlarmViewModel.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/15/25.
//

import Foundation
import Alamofire

class AlarmViewModel{
    var responseDto: AlarmResponse? {
        didSet {
            onResponseDtoUpdated?(responseDto)
        }
    }
    var onResponseDtoUpdated: ((AlarmResponse?) -> Void)?
    
    func fetchAllAlarms(completion: (() -> Void)? = nil) {
        print("API 호출 시작 - fetchAllAlarms")
        let url = "https://myhands.store/alarm"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "토큰 없음")"
        ]
        
        print("요청 URL: \(url)")
        print("요청 헤더: \(headers)")
     
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: APIResponse<AlarmResponse>.self) { response in
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
