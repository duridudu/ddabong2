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
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    //    private let scrollView = UIScrollView()
    //    private let topView = UIView()
    
    //    private let  stackView = UIStackView()
    //    private let containerView = UIStackView()
    var responseDTO: QuestResponseDTO?
    var viewModel = QuestViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI 구성
        // setupScrollView()
        // setupTopView()
        //        setupWeekData()
        // 데이터 로드 및 UI 갱신
        // 뷰 모델에서 데이터를 가져오고 완료 후 UI 업데이트
        viewModel.fetchWeeklyQuests(year: 2025, month: 1) { [weak self] in
            DispatchQueue.main.async {
                self?.loadData()
                
            }
        }
    }
    
    
    func setupScrollView() {
        // top
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        
        // 스크롤 영역
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .cyan
        view.addSubview(scrollView)
        
        // 스크롤뷰에 들어가는 세로 스택뷰
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70), // 고정 높이
            
            
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            
            
        ])
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
//        let jsonData = Data(jsonString.utf8)
//        do {
//           // let decodedData = try JSONDecoder().decode(QuestResponseDTO.self, from: jsonData)
//
//        } catch {
//            print("Failed to decode JSON: \(error)")
//        }
    }
    
    
    
    
    
    func setupViewsForWeeks() {
        guard let responseDTO = responseDTO else { return }
        
        for (weekIndex, quests) in responseDTO.questList.enumerated() {
            // 주차별로 UIView를 생성
            let containerView = QuestMonthlyView()
            containerView.lblWeek.text = "\(weekIndex + 1)주차"
            
            // 가장 많이 얻은 분류에 따른 배경색, 원 이미지 설정
            containerView.tableView.backgroundColor = UIColor(hex: "fff8f8") // 원하는 배경색 설정
            containerView.tableView.tag = weekIndex
            containerView.quests = quests
            
            stackView.addArrangedSubview(containerView)  // 이 부분 추가!
            
        }
        
    }
    
}
