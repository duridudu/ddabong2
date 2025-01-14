import Alamofire
class BoardAllViewModel {
    private var boards: [Board] = []
    private(set) var hasMoreData: Bool = true // 추가 데이터 여부 확인
    var onBoardsUpdated: (() -> Void)?

    func fetchAllBoards(size: Int, lastId: Int?) {
        guard hasMoreData else { return } // 더 이상 데이터가 없으면 리턴

        let url = "https://myhands.store/board/list"
        var parameters: [String: Any] = ["size": size]
        if let lastId = lastId {
            parameters["lastId"] = lastId
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ]

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: BoardResponse.self) { response in
                switch response.result {
                case .success(let boardResponse):
                    let newBoards = boardResponse.responseDto
                    if newBoards.isEmpty {
                        self.hasMoreData = false // 추가 데이터 없음
                    } else {
                        self.boards.append(contentsOf: newBoards)
                        self.updateLastFetchedId(newBoards: newBoards)
                    }
                    self.onBoardsUpdated?()
                case .failure(let error):
                    print("API 요청 실패: \(error.localizedDescription)")
                }
            }
    }

    func getBoards() -> [Board] {
        return boards
    }

    private func updateLastFetchedId(newBoards: [Board]) {
        if let lastBoard = newBoards.last {
            UserSessionManager.shared.setLastFetchedId(lastBoard.boardId) // 마지막 게시물 ID 저장
        }
    }
}
