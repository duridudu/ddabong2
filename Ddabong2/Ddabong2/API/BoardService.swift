import Alamofire
import Foundation

class BoardService {
    static let shared = BoardService()

    private init() {}

    func createBoard(title: String, content: String, completion: @escaping (Result<CreateBoardResponse, Error>) -> Void) {
        let url = "https://myhands.store/board/create"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]
        let parameters = CreateBoardRequest(title: title, content: content)

        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: CreateBoardResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
