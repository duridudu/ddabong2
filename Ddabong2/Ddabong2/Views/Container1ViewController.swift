//
//  Container1ViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/11/25.
//

import Foundation
import UIKit
class Container1ViewController:UIViewController{
    @IBOutlet weak var bg1: UILabel!
    @IBOutlet weak var bg2: UILabel!
    @IBOutlet weak var bg0: UILabel!
    @IBOutlet weak var lblLongestWeek: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblWeeksCnt: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var uiView3: UIView!
    
    @IBOutlet weak var lblTitle3: UILabel!
    var expHistory: [String: Int] = [:]
    var resultList: [String] = []
    var historySize:Int = 0
    
    // MARK: - ViewModel
    private let userInfoViewModel = UserInfoViewModel()
    private let viewModel = QuestViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // user 이름 설정
        fetchUserInfo()
        // 정렬된 키와 값
        let sortedKeys = self.expHistory.keys.sorted(by: <)
        let sortedValues = sortedKeys.map { expHistory[$0]! }
//        let sortedKeys = ["2023", "2022", "2021", "2020"]
//        let sortedValues = [12000, 10000, 7000, 7000]
        
        view.backgroundColor = UIColor(hex: "fff8f8")
        // 테두리 및 corner radius 설정
        bg1.layer.borderWidth = 2.0 // 테두리 두께
        bg1.backgroundColor = .white
        bg1.layer.borderColor = UIColor(hex: "eaeaea").cgColor // 테두리 색상
        bg1.layer.cornerRadius = 40.0 // 테두리의 둥글기
        bg1.layer.masksToBounds = true // corner radius가 적용되도록 설정
        
        // 테두리 및 corner radius 설정
        bg2.layer.borderWidth = 2.0 // 테두리 두께
        bg2.backgroundColor = .white
        bg2.layer.borderColor = UIColor(hex: "eaeaea").cgColor // 테두리 색상
        bg2.layer.cornerRadius = 40.0 // 테두리의 둥글기
        bg2.layer.masksToBounds = true // corner radius가 적용되도록 설정
        
        // 테두리 및 corner radius 설정
        bg0.layer.borderWidth = 2.0 // 테두리 두께
        bg0.backgroundColor = .white
        bg0.layer.borderColor = UIColor(hex: "eaeaea").cgColor // 테두리 색상
        bg0.layer.cornerRadius = 40.0 // 테두리의 둥글기
        bg0.layer.masksToBounds = true // corner radius가 적용되도록 설정

        
        let graphView = BarGraphView()
        graphView.data = sortedValues // sortedValues
        graphView.labels = sortedKeys// sortedKeys
        graphView.backgroundColor = .white
        graphView.frame = CGRect(x: 16, y: 100, width: uiView3.frame.width, height: 300)
        graphView.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃 설정을 활성화
        
        uiView3.addSubview(graphView)
        
        // 오토레이아웃 제약조건 설정
           NSLayoutConstraint.activate([
            graphView.centerXAnchor.constraint(equalTo: uiView3.centerXAnchor), // uiView3의 가로 중앙에 맞춤
               graphView.widthAnchor.constraint(equalTo: uiView3.widthAnchor, multiplier: 0.8), // uiView3의 너비의 80%로 설정
               graphView.topAnchor.constraint(equalTo: lblTitle3.bottomAnchor, constant: 20), // 적절한 상단 여백
               graphView.bottomAnchor.constraint(equalTo: uiView3.bottomAnchor, constant: -16) // 적절한 하단 여백
           ])
        
        
    }
    
    // MARK: - Fetch User Info
    private func fetchUserInfo() {
        userInfoViewModel.fetchUserInfo()
        userInfoViewModel.onUserInfoFetchSuccess = { [weak self] in
            DispatchQueue.main.async {
                guard let user = self?.userInfoViewModel.userInfo else { return }
                self?.updateUI(with: user)
            }
        }
        userInfoViewModel.onUserInfoFetchFailure = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    // 이름 설정
    private func updateUI(with user: User) {
        print("이름 설정 - ", user.name)
        lblName.text = "현재 \(user.name)님은"
    }
    
    
    private func setupBindings() {
        viewModel.fetchQuestStats()
        // 성공 시 데이터 처리
        viewModel.responseDto = { [weak self] dto in
            guard let self = self, let dto = dto else { return }
            DispatchQueue.main.async {
                self.lblWeeksCnt.text = "\(dto.challengeCount)주"
                self.lblPercent.text = "\(dto.maxCount)%"
                self.lblLongestWeek.text = "\(dto.maxCount)주🔥"
                self.expHistory = dto.expHistory
                self.resultList = dto.resultList
                self.historySize = dto.historySize
            }
        }
    }
    
}
