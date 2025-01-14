//
//  MyPageViewModel.swift
//  Ddabong2
//
//  Created by 안지희 on 1/13/25.
//


import Foundation
import Alamofire

class MyPageViewModel {
    var onMyPageFetchSuccess: (() -> Void)?
    var onMyPageFetchFailure: ((String) -> Void)?

    var myPageData: MyPageResponseDto? // 접근 수준 변경

    func fetchMyPageData() {
        let url = "https://myhands.store/user/mypage"
        let headers: [String: String] = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]

        AF.request(url, method: .get, headers: HTTPHeaders(headers))
            .responseDecodable(of: MyPageResponse.self) { response in
                switch response.result {
                case .success(let myPageResponse):
                    if myPageResponse.status == "OK" {
                        self.myPageData = myPageResponse.responseDto
                        self.onMyPageFetchSuccess?()
                    } else {
                        self.onMyPageFetchFailure?("데이터를 가져오는 데 실패했습니다.")
                    }
                case .failure(let error):
                    self.onMyPageFetchFailure?(error.localizedDescription)
                }
            }
    }
}
