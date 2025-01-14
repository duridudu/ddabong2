import Alamofire

class CreateUserService {
    static let shared = CreateUserService()

    private init() {}

    func createUser(name: String, id: String, password: String, joinedAt: String, departmentId: Int, jobGroup: Int, group: String, completion: @escaping (Bool, String?) -> Void) {
        let url = "https://myhands.store/user/join"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "name": name,
            "id": id,
            "password": password,
            "joinedAt": joinedAt,
            "departmentId": departmentId,
            "jobGroup": jobGroup,
            "group": group
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: CreateUserResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.status == "CREATED" {
                        completion(true, nil)
                    } else {
                        completion(false, data.message)
                    }
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
    }
}
