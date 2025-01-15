import Alamofire
import Foundation

class AdminUserListViewModel {
    static let shared = AdminUserListViewModel()

    private init() {}

    func fetchUserList(completion: @escaping (Result<[UserListItem], Error>) -> Void) {
        let url = "https://myhands.store/user/list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]

        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: AdminUserListResponse.self) { response in
                switch response.result {
                case .success(let adminUserListResponse):
                    completion(.success(adminUserListResponse.responseDto))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

