//JH
//API 호출
//데이터 가져오기~~~

import Alamofire
import UIKit

class BoardViewModel {
    private var boards: [Board] = [] // 게시글 데이터 저장
    var onBoardsUpdated: (() -> Void)? // 데이터 업데이트 콜백
    var isSearchMode: Bool = false // 검색 모드 여부

    // 데이터 가져오기
    func fetchBoards(size: Int, lastId: Int? = nil) {
        guard !isSearchMode else { return } // 검색 중에는 일반 데이터 요청을 막음

        let url = "https://myhands.store/board/list"
        var parameters: [String: Any] = ["size": size]
        if let lastId = lastId {
            parameters["lastId"] = lastId
        }

        AF.request(url, method: .get, parameters: parameters, headers: [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ])
        .responseDecodable(of: BoardResponse.self) { response in
            switch response.result {
            case .success(let boardResponse):
                if lastId == nil {
                    self.boards = boardResponse.responseDto // 초기 데이터 요청
                } else {
                    self.boards += boardResponse.responseDto // 추가 데이터 요청
                }
                self.onBoardsUpdated?()
            case .failure(let error):
                print("Error fetching boards: \(error.localizedDescription)")
            }
        }
    }

    // 검색
    func searchBoards(word: String, size: Int, lastId: Int? = nil) {
        isSearchMode = true // 검색 모드 활성화
        let url = "https://myhands.store/board/search"
        var parameters: [String: Any] = ["size": size, "word": word]
        if let lastId = lastId {
            parameters["lastId"] = lastId
        }

        AF.request(url, method: .get, parameters: parameters, headers: [
            "Authorization": "Bearer \(UserSessionManager.shared.getAccessToken() ?? "")"
        ])
        .responseDecodable(of: BoardResponse.self) { response in
            switch response.result {
            case .success(let boardResponse):
                if lastId == nil {
                    self.boards = boardResponse.responseDto // 검색 결과로 초기화
                } else {
                    self.boards += boardResponse.responseDto // 검색 결과 추가
                }
                self.onBoardsUpdated?()
            case .failure(let error):
                print("Error searching boards: \(error.localizedDescription)")
            }
        }
    }

    // 데이터 초기화
    func resetSearch() {
        isSearchMode = false
        fetchBoards(size: 20) // 검색 종료 후 전체 데이터 다시 가져오기
    }

    func getBoards() -> [Board] {
        return boards
    }
}
