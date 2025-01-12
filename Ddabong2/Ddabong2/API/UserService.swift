//JH

import Alamofire

class UserService {
    static let shared = UserService() // 싱글턴 패턴

    private init() {}

    func fetchUserInfo(accessToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = "https://myhands.store/user/info"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]

        // Alamofire 요청
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userResponse):
                    let userInfo = userResponse.responseDto
                    print("유저 정보 가져오기 성공: \(userInfo)")
                    completion(.success(userInfo))
                case .failure(let error):
                    print("유저 정보 가져오기 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
