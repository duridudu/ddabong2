//
//  QuestViewModel.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/12/25.
//

import Foundation
import Alamofire

class QuestViewModel{
    var responseDto: ((QuestStatsResponseDto?)->(Void))? // 퀘스트통계 결과
    var onQuestsUpdated: (() -> Void)? // 데이터 업데이트 콜백

    var responseDto2: QuestResponseDTO? // 퀘스트주간 결과
    
    func fetchQuestStats() {
        print("API 호출 시작")
        let url = "https://myhands.store/quest/stats"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "토큰 없음")"
        ]
        print("ACCESS TOKEN",UserSessionManager.shared.getAccessToken())
//        let parameters: [String: Any] = ["size": size]
        print("요청 URL: \(url)")
        print("요청 헤더: \(headers)")
//        print("요청 파라미터: \(parameters)")

        AF.request(url, method: .get, headers: headers).responseDecodable(of: APIResponse<QuestStatsResponseDto>.self) { response in
            switch response.result {
            case .success(let data):
                // 성공적으로 디코딩한 데이터 사용
                print("Status: \(data.status)")
                print("Message: \(data.message)")
                print("Challenge Count: \(String(describing: data.responseDto?.challengeCount))")
                print("Quest Rate: \(String(describing: data.responseDto?.questRate))")
                print("Exp History: \(String(describing: data.responseDto?.expHistory))")
                self.responseDto?(data.responseDto) // 성공 데이터를 바인딩
            case .failure(let error):
                // 오류 처리
                print("Error: \(error)")
            }
        }
    }

    func fetchWeeklyQuests(year: Int, month: Int, completion: @escaping () -> Void) {
        print("API 호출 시작 - fetchWeeklyQuests")
        let url = "https://myhands.store/quest/calendar-ios"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "토큰 없음")"
        ]
        
        let parameters: [String: Any] = [
                "year": year,
                "month": month
            ]
        
        print("요청 URL: \(url)")
        print("요청 헤더: \(headers)")
        print("요청 파라미터: \(parameters)")

        AF.request(url, method: .get,
                   parameters: parameters, headers: headers)
            .responseDecodable(of: APIResponse<QuestResponseDTO>.self) { response in
            switch response.result {
            case .success(let data):
                // 성공적으로 디코딩한 데이터 사용
                print("Status: \(data.status)")
                print("Message: \(data.message)")
                self.responseDto2 = data.responseDto // 성공 데이터를 바인딩
            case .failure(let error):
                // 오류 처리
                print("Error: \(error)")
            }
            completion() // 데이터 처리 후 완료 콜백 호출
        }
    }

    
}
