//JH
//유저정보가져오기
//햄버거에서 쓸겁니다요


import Alamofire

class UserInfoViewModel {
    var userInfo: User? // 유저 정보를 저장
    var onUserInfoFetchSuccess: (() -> Void)?
    var onUserInfoFetchFailure: ((String) -> Void)?

    func fetchUserInfo() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            onUserInfoFetchFailure?("Access Token이 없습니다.")
            return
        }

        let url = "https://myhands.store/user/info"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userResponse):
                    self.userInfo = userResponse.responseDto
                    self.onUserInfoFetchSuccess?()
                case .failure(let error):
                    self.onUserInfoFetchFailure?("유저 정보를 가져오는 데 실패했습니다: \(error.localizedDescription)")
                }
            }
    }
    
    
}
