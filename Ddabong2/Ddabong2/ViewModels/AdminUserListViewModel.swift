import Alamofire

class AdminUserListViewModel {
    
    /*
    private var users: [User] = [] // 여러 사용자 데이터를 저장
    var onUserListUpdated: (() -> Void)? // 데이터 업데이트 성공 콜백
    var onFetchFailure: ((String) -> Void)? // 실패 시 메시지 전달 콜백

    func fetchUserList() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            onFetchFailure?("로그인 토큰이 없습니다.")
            return
        }

        let url = "https://myhands.store/user/list" // 다수 사용자 데이터를 가져오는 API
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        // 다수 사용자 데이터를 처리하는 UserListResponse 사용
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: UserListResponse.self) { response in
                switch response.result {
                case .success(let userListResponse):
                    if userListResponse.status == "OK" {
                        self.users = userListResponse.responseDto // 여러 사용자 정보 저장
                        self.onUserListUpdated?() // 성공 콜백 호출
                    } else {
                        self.onFetchFailure?(userListResponse.message)
                    }
                case .failure(let error):
                    self.onFetchFailure?("유저 목록을 가져오는 데 실패했습니다: \(error.localizedDescription)")
                }
            }
    }

    func getUsers() -> [User] {
        return users
    }
     */
}
