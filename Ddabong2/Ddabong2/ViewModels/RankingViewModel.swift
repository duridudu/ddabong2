import Foundation

class RankingViewModel {
    private var rankings: [Rank] = []
    var myIndex: Int? // 내 순위
    var needExp: Int? // 목표 경험치까지 남은 값
    var remainingTime: String = "" // 남은 시간 텍스트
    var currentPeriod: String = "" // 현재 주차 정보
    var onRankingsUpdated: (() -> Void)? // 뷰 업데이트 클로저
    var onTimeUpdated: (() -> Void)? // 시간 업데이트 클로저

    func fetchRankings() {
        RankingService.shared.fetchRankings { [weak self] result in
            switch result {
            case .success(let rankingDto):
                self?.rankings = rankingDto.rankList
                self?.myIndex = rankingDto.myIndex
                self?.needExp = rankingDto.needExp
                self?.onRankingsUpdated?()
            case .failure(let error):
                print("Error fetching rankings: \(error.localizedDescription)")
            }
        }
    }

    func getRankings() -> [Rank] {
        return rankings
    }

    // 주간 종료 시간 계산
    func calculateRemainingTime() {
        let calendar = Calendar.current
        let now = Date()
        
        // 이번 주의 마지막 일요일 23:59:59 계산
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        if let startOfWeek = calendar.date(from: components) {
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)?.addingTimeInterval(86399) // 일요일 끝
            if let endOfWeek = endOfWeek {
                let remainingSeconds = Int(endOfWeek.timeIntervalSince(now))
                if remainingSeconds > 0 {
                    let days = remainingSeconds / (24 * 3600)
                    let hours = (remainingSeconds % (24 * 3600)) / 3600
                    let minutes = (remainingSeconds % 3600) / 60
                    let seconds = remainingSeconds % 60
                    self.remainingTime = "\(days)일 \(hours)시간 \(minutes)분 \(seconds)초"
                } else {
                    self.remainingTime = "랭킹 마감!"
                }
                self.onTimeUpdated?()
            }
        }
    }

    // 현재 주차 계산
    func calculateCurrentPeriod() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .weekOfYear], from: now)

        if let year = components.year, let weekOfYear = components.weekOfYear {
            self.currentPeriod = "\(year)년 \(weekOfYear)주차"
        } else {
            self.currentPeriod = "알 수 없음"
        }
    }

    // 1초마다 시간 업데이트
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.calculateRemainingTime()
        }
    }
}
