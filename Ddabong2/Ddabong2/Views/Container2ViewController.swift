//
//  Container2ViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/11/25.
//

import Foundation
import UIKit

class Container2ViewController:UIViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBOutlet weak var lblYearMonth: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    
    @IBOutlet weak var lblTotalScore2: UILabel!
    @IBOutlet weak var lblTotalScore1: UILabel!
    
    @IBOutlet weak var lblTotalScore4: UILabel!
    @IBOutlet weak var lblTotalScore3: UILabel!
   
    @IBOutlet weak var lblFirstTitle2: UILabel!
    
    @IBOutlet weak var lblFirstScore1: UILabel!
    @IBOutlet weak var lblFirstTitle3: UILabel!
    @IBOutlet weak var lblFirstTitle1: UILabel!
    
    @IBOutlet weak var lblFirstScore2: UILabel!
    
    @IBOutlet weak var lblFirstScore3: UILabel!
    
    
    @IBOutlet weak var lblSecondTitle1: UILabel!
    
    @IBOutlet weak var lblSecondScore3: UILabel!
    @IBOutlet weak var lblSecondScore2: UILabel!
    @IBOutlet weak var lblSecondScore1: UILabel!
    @IBOutlet weak var lblSecondTitle3: UILabel!
    @IBOutlet weak var lblSecondTitle2: UILabel!
    
    @IBOutlet weak var lblThirdScore3: UILabel!
    @IBOutlet weak var lblThirdScore2: UILabel!
    @IBOutlet weak var lblThirdScore1: UILabel!
    @IBOutlet weak var lblThirdTitle3: UILabel!
    @IBOutlet weak var lblThirdTitle2: UILabel!
    @IBOutlet weak var lblThirdTitle1: UILabel!
    
    @IBOutlet weak var lblFourthTitle1: UILabel!
    
    @IBOutlet weak var lblFourthTitle2: UILabel!
    
    @IBOutlet weak var lblFourthTitle3: UILabel!
    
    @IBOutlet weak var lblFourthScore3: UILabel!
    @IBOutlet weak var lblFourthScore2: UILabel!
    @IBOutlet weak var lblFourthScore1: UILabel!
    
    @IBOutlet weak var imgFirst1: UIImageView!
    @IBOutlet weak var imgFirst2: UIImageView!
    @IBOutlet weak var imgFirst3: UIImageView!
    
    @IBOutlet weak var imgSecond1: UIImageView!
    @IBOutlet weak var imgSecond3: UIImageView!
    @IBOutlet weak var imgSecond2: UIImageView!
    
    @IBOutlet weak var imgThird3: UIImageView!
    @IBOutlet weak var imgThird2: UIImageView!
    @IBOutlet weak var imgThird1: UIImageView!
    
    @IBOutlet weak var imgFourth3: UIImageView!
    @IBOutlet weak var imgFourth2: UIImageView!
    @IBOutlet weak var imgFourth1: UIImageView!
    
    var responseDTO: QuestResponseDTO?
    var viewModel = QuestViewModel()
    
    var currentDate: Date = Date() // 초기값은 오늘 날짜

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI 구성
        // 뷰 모델에서 데이터를 가져오고 완료 후 UI 업데이트
        viewModel.fetchWeeklyQuests(year: 2025, month: 1) { [weak self] in
            DispatchQueue.main.async {
                self?.loadData()
                
            }
        }
    }
    
   
    func setupTopView() {
        let lblTitle = UILabel()
        lblTitle.text = "2025년 1월"
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(lblTitle)
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: topView.topAnchor, constant: 30),
            lblTitle.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 30)
        ])
        
    }
    func loadData(){
        // 예제 JSON 데이터 로드
//        let jsonString = """
//           """
        responseDTO = viewModel.responseDto2
        setupViewsForWeeks()
    }
    
    
    
    
    func setupViewsForWeeks() {
        guard let responseDTO = responseDTO else { return }
        
        for (weekIndex, quests) in responseDTO.questList.enumerated() {
            // 주차별로 UIView를 생성
            if weekIndex == 1 {
                setFirstWeek(quests:quests)
            }
            else if weekIndex == 2{
                setSecondWeek(quests:quests)
            }
            else if weekIndex == 3{
               setThirdWeek(quests:quests)
            }
            else if weekIndex == 4{
               setFourthWeek(quests:quests)
            }
            else{
                
            }
        }
        
    }
    @IBAction func btnFuture(_ sender: Any) {
        let calendar = Calendar.current
    // 이전 달 계산 (-1 month)
        if let previousMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = previousMonth
                
        // 연도와 월 분리
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        if let year = components.year, let month = components.month {
            print("이전 달: \(year).\(month)") // 예: "2024.12"
            lblYearMonth.text = "\(year)년 \(month)월"
            // 뷰 모델에서 데이터를 가져오고 완료 후 UI 업데이트
            viewModel.fetchWeeklyQuests(year: year, month: month) { [weak self] in
                DispatchQueue.main.async {
                    self?.loadData()
                    
                }
            }
        }
    }

    }
    
    @IBAction func btnPrev(_ sender: Any) {
        let calendar = Calendar.current
    // 이전 달 계산 (-1 month)
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = previousMonth
                
        // 연도와 월 분리
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        if let year = components.year, let month = components.month {
            lblYearMonth.text = "\(year)년 \(month)월"
            // 뷰 모델에서 데이터를 가져오고 완료 후 UI 업데이트
            viewModel.fetchWeeklyQuests(year: year, month: month) { [weak self] in
                DispatchQueue.main.async {
                    self?.loadData()
                    
                }
            }
        }
    }
    }
    
    func setFirstWeek(quests:[Quest]){
        // 총 경험치나 퀘스트의 첫 번째 데이터를 기반으로 값 설정
        let totalExp = quests.reduce(0) { $0 + $1.expAmount }
        lblTotalScore1.text = " \(totalExp)D "
               
        // 테두리 설정
        lblTotalScore1.layer.borderColor = UIColor(hex:"ff5b35").cgColor
        lblTotalScore1.layer.borderWidth = 2
        lblTotalScore1.layer.backgroundColor = UIColor(hex:"fff4f4").cgColor
        
        // 레이디어스 설정 (둥근 모서리)
        lblTotalScore1.layer.cornerRadius = 8 // 원하는 반경 값
        lblTotalScore1.layer.masksToBounds = true // 경계가 잘리도록 설정
    
        stackView1.layer.cornerRadius = 8
        
        let labels = [lblFirstTitle1, lblFirstTitle2, lblFirstTitle3]
        let scores = [lblFirstScore1,lblFirstScore2,lblFirstScore3]
        let images = [imgFirst1, imgFirst2, imgFirst3]
        
        // 색 설정
        for (index, label) in labels.enumerated() {
            if index < quests.count {
                label?.text = quests[index].name
                label?.isHidden = false // 데이터가 있는 라벨은 표시
                scores[index]?.text = "\(quests[index].expAmount)D"
            } else {
                label?.isHidden = true // 데이터가 없는 라벨은 숨김
                scores[index]?.isHidden = true
                images[index]?.isHidden = true
            }
        }
        
        let itemHeight: CGFloat = 30.0 // 각 하위 뷰의 높이 (필요에 따라 조정)
        let spacing: CGFloat = 1.0   // 하위 뷰 간 간격 (필요에 따라 조정)
        let visibleCount = quests.count
        // 새로운 높이 계산
        let totalHeight = CGFloat(visibleCount) * itemHeight + CGFloat(visibleCount - 1) * spacing
        
        // 스택뷰 높이 제약 조건 업데이트
        if let heightConstraint = stackView1.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = totalHeight
        } else {
            stackView1.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        }
        
        // 레이아웃 업데이트
        stackView1.layoutIfNeeded()
        
    }
    
    func setSecondWeek(quests:[Quest]){
        // 총 경험치나 퀘스트의 첫 번째 데이터를 기반으로 값 설정
        let totalExp = quests.reduce(0) { $0 + $1.expAmount }
        lblTotalScore2.text = " \(totalExp)D "
               
        // 테두리 설정
        lblTotalScore2.layer.borderColor = UIColor(hex:"ff5b35").cgColor
        lblTotalScore2.layer.borderWidth = 2
               
        // 레이디어스 설정 (둥근 모서리)
        lblTotalScore2.layer.cornerRadius = 8 // 원하는 반경 값
        lblTotalScore2.layer.masksToBounds = true // 경계가 잘리도록 설정
    
        stackView2.layer.cornerRadius = 10
        let labels = [lblSecondTitle1, lblSecondTitle2, lblSecondTitle3]
        let scores = [lblSecondScore1,lblSecondScore2,lblSecondScore3]
        let images = [imgSecond1, imgSecond2, imgSecond3]
        // 색 설정
        for (index, label) in labels.enumerated() {
            if index < quests.count {
                label?.text = quests[index].name
                label?.isHidden = false // 데이터가 있는 라벨은 표시
                scores[index]?.text = "\(quests[index].expAmount)D"
            } else {
                label?.isHidden = true // 데이터가 없는 라벨은 숨김
                scores[index]?.isHidden = true
                images[index]?.isHidden = true
            }
        }
        
        // 스택뷰 높이 조정
            let itemHeight: CGFloat = 30.0 // 각 하위 뷰의 높이 (필요에 따라 조정)
            let spacing: CGFloat = 1.0   // 하위 뷰 간 간격 (필요에 따라 조정)
            let visibleCount = quests.count
            
            // 새로운 높이 계산
            let totalHeight = CGFloat(visibleCount) * itemHeight + CGFloat(visibleCount - 1) * spacing
            
            // 스택뷰 높이 제약 조건 업데이트
            if let heightConstraint = stackView2.constraints.first(where: { $0.firstAttribute == .height }) {
                heightConstraint.constant = totalHeight
            } else {
                stackView2.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
            }
            
            // 레이아웃 업데이트
            stackView2.layoutIfNeeded()
        
    }
    
    func setThirdWeek(quests:[Quest]){
        // 총 경험치나 퀘스트의 첫 번째 데이터를 기반으로 값 설정
        let totalExp = quests.reduce(0) { $0 + $1.expAmount }
        lblTotalScore3.text = " \(totalExp)D "
               
        // 테두리 설정
        lblTotalScore3.layer.borderColor = UIColor(hex:"ff5b35").cgColor
        lblTotalScore3.layer.borderWidth = 2
               
        // 레이디어스 설정 (둥근 모서리)
        lblTotalScore3.layer.cornerRadius = 8 // 원하는 반경 값
        lblTotalScore3.layer.masksToBounds = true // 경계가 잘리도록 설정
    
        stackView3.layer.cornerRadius = 10
        let labels = [lblThirdTitle1, lblThirdTitle2, lblThirdTitle3]
        let scores = [lblThirdScore1,lblThirdScore2,lblThirdScore3]
        let images = [imgThird1, imgThird2, imgThird3]
        
        // 색 설정
        for (index, label) in labels.enumerated() {
            if index < quests.count {
                label?.text = quests[index].name
                label?.isHidden = false // 데이터가 있는 라벨은 표시
                scores[index]?.text = "\(quests[index].expAmount)D"
                
                // 이미지 색 설정
            } else {
                label?.isHidden = true // 데이터가 없는 라벨은 숨김
                scores[index]?.isHidden = true
                images[index]?.isHidden = true
            }
        }
        
        let itemHeight: CGFloat = 30.0 // 각 하위 뷰의 높이 (필요에 따라 조정)
        let spacing: CGFloat = 1.0   // 하위 뷰 간 간격 (필요에 따라 조정)
        let visibleCount = quests.count
        // 새로운 높이 계산
        let totalHeight = CGFloat(visibleCount) * itemHeight + CGFloat(visibleCount - 1) * spacing
        
        // 퀘스트 내역이 없다면
        if quests.count == 0{
            lblThirdTitle1.isHidden = false
            lblThirdTitle1.text = "퀘스트 내역이 존재하지 않습니다."
            lblThirdScore1.isHidden = true
            imgThird1.isHidden = true
            stackView3.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
        } else{
            // 스택뷰 높이 제약 조건 업데이트
            if let heightConstraint = stackView3.constraints.first(where: { $0.firstAttribute == .height }) {
                heightConstraint.constant = totalHeight
            } else {
                stackView3.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
            }
            
        }
        // 레이아웃 업데이트
        stackView3.layoutIfNeeded()
       
        
    }
    
    func setFourthWeek(quests:[Quest]){
        // 총 경험치나 퀘스트의 첫 번째 데이터를 기반으로 값 설정
        let totalExp = quests.reduce(0) { $0 + $1.expAmount }
        lblTotalScore4.text = " \(totalExp)D "
               
        // 테두리 설정
        lblTotalScore4.layer.borderColor = UIColor(hex:"ff5b35").cgColor
        lblTotalScore4.layer.borderWidth = 1
               
        // 레이디어스 설정 (둥근 모서리)
        lblTotalScore4.layer.cornerRadius = 8 // 원하는 반경 값
        lblTotalScore4.layer.masksToBounds = true // 경계가 잘리도록 설정
    
        stackView4.layer.cornerRadius = 10
        let labels = [lblFourthTitle1, lblFourthTitle2, lblFourthTitle3]
        let scores = [lblFourthScore1,lblFourthScore2,lblFourthScore3]
        let images = [imgFourth1, imgFourth2, imgFourth3]
        // 색 설정
        for (index, label) in labels.enumerated() {
            if index < quests.count {
                label?.text = quests[index].name
                label?.isHidden = false // 데이터가 있는 라벨은 표시
                scores[index]?.text = "\(quests[index].expAmount)D"
                
                // 이미지 색 설정
            } else {
                label?.isHidden = true // 데이터가 없는 라벨은 숨김
                scores[index]?.isHidden = true
                images[index]?.isHidden = true
            }
        }
        let itemHeight: CGFloat = 30.0 // 각 하위 뷰의 높이 (필요에 따라 조정)
        let spacing: CGFloat = 1.0   // 하위 뷰 간 간격 (필요에 따라 조정)
        let visibleCount = quests.count
        
        // 새로운 높이 계산
        let totalHeight = CGFloat(visibleCount) * itemHeight + CGFloat(visibleCount - 1) * spacing
        
        // 스택뷰 높이 제약 조건 업데이트
        if let heightConstraint = stackView4.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = totalHeight
        } else {
            stackView4.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        }
        
        // 레이아웃 업데이트
        stackView4.layoutIfNeeded()
    }
    
    
}
