//
//  Container2ViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/11/25.
//

import Foundation
import UIKit

class Container2ViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TABLE",responseDTO?.questList[tableView.tag].count ?? 0)
        return responseDTO?.questList[tableView.tag].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("TABLE CELL")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        guard let quest = responseDTO?.questList[tableView.tag][indexPath.row] else { return cell }
        cell.textLabel?.text = "\(quest.name)   \(quest.expAmount)D"
        cell.backgroundColor = UIColor(hex: "fff8f8") // 원하는 배경색 (예: 밝은 베이지)
        // 선택 시 배경색 제거
           let bgView = UIView()
           bgView.backgroundColor = .clear
           cell.selectedBackgroundView = bgView

        //        cell.detailTextLabel?.text = "Exp: \(quest.expAmount) | Grade: \(quest.grade)"
        return cell
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    //    private let scrollView = UIScrollView()
    //    private let topView = UIView()
    
    //    private let  stackView = UIStackView()
    //    private let containerView = UIStackView()
    var responseDTO: QuestResponseDTO?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI 구성
        // setupScrollView()
        // setupTopView()
        //        setupWeekData()
        // 데이터 로드 및 UI 갱신
        loadData()
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
    
    func setupWeekData(){
        // 주차별로 UIView를 생성
        //        let containerView = UIView()
        //        containerView.translatesAutoresizingMaskIntoConstraints = false
        //        containerView.backgroundColor = .blue
        //
        //        containerView.addSubview(experienceTitleLabel)
        
        print("WEEK", 1)
        let lblTitle = UILabel()
        lblTitle.text = "WEEK 1"
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        //        stackView.addArrangedSubview(lblTitle)  // 이 부분 추가!
        
    }
    
    func loadData() {
        // 예제 JSON 데이터 로드
        let jsonString = """
           {
               "weekCount": 4,
               "questList": [
                   [
                       {
                           "questId": 1,
                           "questType": "company",
                           "name": "AAA 프로젝트 참여",
                           "grade": "",
                           "expAmount": 800,
                           "isCompleted": true,
                           "completedAt": "2024-01-22T10:30:00.123",
                           "imageUrl": "https://example.com/image1.png"
                       },
                       {
                           "questId": 2,
                           "questType": "leader",
                           "name": "월특근",
                           "grade": "MAX",
                           "expAmount": 80,
                           "isCompleted": true,
                           "completedAt": "2024-01-25T10:30:00.123",
                           "imageUrl": "https://example.com/image2.png"
                       }
                   ],
                   [
                       {
                           "questId": 4,
                           "questType": "hr",
                           "name": "인사평가 S 등급 달성",
                           "grade": "S",
                           "expAmount": 6500,
                           "isCompleted": true,
                           "completedAt": "2025-3-27T10:30:00.123",
                           "imageUrl": "https://example.com/image3.png"
                       },
                       {
                           "questId": 3,
                           "questType": "job",
                           "name": "생산성 MAX 달성",
                           "grade": "MAX",
                           "expAmount": 40,
                           "isCompleted": true,
                           "completedAt": "2025-02-26T10:30:00.123",
                           "imageUrl": "https://example.com/image4.png"
                       }
                   ],
                   []
               ]
           }
           """
        
        let jsonData = Data(jsonString.utf8)
        do {
            let decodedData = try JSONDecoder().decode(QuestResponseDTO.self, from: jsonData)
            responseDTO = decodedData
            setupViewsForWeeks()
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    func setupViewsForWeeks() {
        guard let responseDTO = responseDTO else { return }
        
        for (weekIndex, quests) in responseDTO.questList.enumerated() {
            // 주차별로 UIView를 생성
            let containerView = UIStackView()
            containerView.axis = .horizontal
            containerView.spacing = 10
            containerView.alignment = .fill
            containerView.distribution = .fill
            containerView.translatesAutoresizingMaskIntoConstraints = false
            // **`containerView`에 높이 설정**
            NSLayoutConstraint.activate([
                containerView.heightAnchor.constraint(equalToConstant: 150), // 고정 높이
            ])
            
            print("WEEK", weekIndex)
            
            let weekLabelView = UIStackView()
            weekLabelView.axis = .vertical
            weekLabelView.spacing = 7
            weekLabelView.alignment = .fill
            weekLabelView.distribution = .fill
            weekLabelView.translatesAutoresizingMaskIntoConstraints = false
            
            // 라벨 추가
            let weekLabel = UILabel()
            weekLabel.text = "\(weekIndex + 1)주차"
            weekLabel.font = UIFont.boldSystemFont(ofSize: 20)
            weekLabel.translatesAutoresizingMaskIntoConstraints = false
            weekLabelView.addArrangedSubview(weekLabel)
            // 라벨 추가(총합 점수)
                        let weekLabel2 = UILabel()
                        weekLabel2.text = "350D"
                        weekLabel2.font = UIFont.boldSystemFont(ofSize: 10)
                        weekLabel2.layer.borderWidth = 2.0 // 테두리 두께
                        weekLabel2.backgroundColor = UIColor(hex:"fff8f8")
                        weekLabel2.layer.borderColor = UIColor(hex:"ff5b35").cgColor // 테두리 색상
                        weekLabel2.layer.cornerRadius = 20.0 // 테두리의 둥글기
                        weekLabel2.layer.masksToBounds = true // corner radius가 적용되도록 설정
            //
                        weekLabel2.translatesAutoresizingMaskIntoConstraints = false
                        weekLabelView.addArrangedSubview(weekLabel2)
            
            //            // 레이아웃 제약 조건 설정
                        NSLayoutConstraint.activate([
                            weekLabel.widthAnchor.constraint(equalToConstant: 40), // 라벨 고정 너비
                            weekLabel.topAnchor.constraint(equalTo: weekLabelView.topAnchor, constant: 5),
                            // weekLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                            weekLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30), // 최소 너비
                            weekLabel.heightAnchor.constraint(equalToConstant: 30) ,// 고정 높이
            
                            weekLabel2.widthAnchor.constraint(equalToConstant: 40), // 라벨 고정 너비
                            weekLabel2.topAnchor.constraint(equalTo: weekLabel.bottomAnchor, constant: 5),
                            // weekLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                            weekLabel2.widthAnchor.constraint(greaterThanOrEqualToConstant: 30), // 최소 너비
                            weekLabel2.heightAnchor.constraint(equalToConstant: 30) ,// 고정 높이
            
                        ])
            
            
            
           containerView.addArrangedSubview(weekLabelView)
            print(containerView)
            
            // 이미지 추가
            // 원형 UIView 생성
            let circleView = UIImageView()
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.image=UIImage(named:"imgChecked")
            containerView.addArrangedSubview(circleView)
            
            //      테이블 뷰 추가
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.tag = weekIndex
            tableView.isScrollEnabled = false
            
            // 테이블 뷰 스타일
                        tableView.backgroundColor = UIColor(hex: "fff8f8") // 원하는 배경색 설정
                        tableView.layer.cornerRadius = 12 // 둥근 모서리 적용
                        tableView.layer.masksToBounds = true // 둥근 모서리가 잘리도록 설정
            //            // 테이블 뷰 줄 제거
                        tableView.separatorStyle = .none
            
            tableView.reloadData()
            containerView.addArrangedSubview(tableView)
            
            
            // 레이아웃 제약 조건 설정
            NSLayoutConstraint.activate([
//                tableView.heightAnchor.constraint(equalToConstant: CGFloat(quests.count * 60)), // 테이블뷰 높이
                
                weekLabelView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                weekLabelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
                weekLabelView.widthAnchor.constraint(equalToConstant: 40), // 라벨 고정 너비
                weekLabelView.heightAnchor.constraint(equalToConstant: 30) ,// 고정 높이
                
               circleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
               circleView.leadingAnchor.constraint(equalTo: weekLabelView.trailingAnchor, constant: 8),
               circleView.widthAnchor.constraint(equalToConstant: 4),
               circleView.heightAnchor.constraint(equalToConstant: 4),
                
                tableView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8),
                tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                
//                containerView.heightAnchor.constraint(equalToConstant: CGFloat(max(quests.count, 1) * 60)) // 테이블뷰의 셀 높이 기준
            ])
            stackView.addArrangedSubview(containerView)  // 이 부분 추가!
            
            
            //            print("StackView frame: \(stackView.frame)")
            //            print("ContainerView frame: \(containerView.frame)")
            
        }
        
        // 데이터가 로드된 후 테이블 뷰 갱신´
        for (weekIndex, quests) in responseDTO.questList.enumerated() {
            if let tableView = view.subviews.compactMap({ $0 as? UIStackView }).first?.arrangedSubviews[weekIndex].subviews.compactMap({ $0 as? UITableView }).first {
                tableView.reloadData()  // 테이블 뷰 데이터 갱신
                print("Reloaded data for tableView of Week \(weekIndex + 1)")
            }
        }
        
    }
    
}

import SwiftUI

struct Container2ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let navigationBarVC = Container2ViewController()
            return navigationBarVC
        }
    }
}

