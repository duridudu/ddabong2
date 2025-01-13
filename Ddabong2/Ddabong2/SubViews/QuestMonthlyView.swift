//
//  QuestMonthlyView.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/13/25.
//

import UIKit

class QuestMonthlyView: UIView , UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    var quests: [Quest] = [] {
            didSet {
                tableView.reloadData()
            }
        }
    
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var lblTotalScore: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var data = ["Row 1", "Row 2", "Row 3"] // 테스트용 데이터

        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        private func commonInit() {
            let nib = UINib(nibName: "QuestMonthlyView", bundle: nil)
            guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
            view.frame = self.bounds
            self.addSubview(view)

            setupTableView()
        }

        private func setupTableView() {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.isScrollEnabled = false
            
            // 테이블 뷰 스타일
            tableView.layer.cornerRadius = 12 // 둥근 모서리 적용
            tableView.layer.masksToBounds = true // 둥근 모서리가 잘리도록 설정
            // 테이블 뷰 줄 제거
            tableView.separatorStyle = .none
            
            // 테이블뷰 셀 등록
            let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "customCell")
        }

        // MARK: - UITableViewDataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return quests.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            let quest = quests[indexPath.row]
            cell.backgroundColor = UIColor(hex: "fff8f8") // 원하는 배경색 (예: 밝은 베이지)
            
            // 선택 시 배경색 제거
            let bgView = UIView()
            bgView.backgroundColor = .clear
            cell.selectedBackgroundView = bgView
            
            
            cell.lblTitle.text = quest.name
            cell.lblScore.text = "\(quest.expAmount)D"
            return cell
        }
    }
    
