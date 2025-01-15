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
            updateTableViewHeight()
        }
    }
    
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var lblTotalScore: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
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
        setupTableViewHeightConstraint()
    }
    
    
    private func updateTableViewHeight() {
           let cellHeight: CGFloat = 20  // 셀의 높이
           let contentHeight = CGFloat(quests.count) * cellHeight
           tableViewHeightConstraint?.constant = contentHeight
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
        updateTableViewHeight()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }
    
    private func setupTableViewHeightConstraint() {
          tableView.translatesAutoresizingMaskIntoConstraints = false
          tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
          tableViewHeightConstraint?.isActive = true
      }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let quest = quests[indexPath.row]
        cell.backgroundColor = UIColor(hex: "fff8f8")
        cell.lblTitle.text = quest.name
        cell.lblScore.text = "\(quest.expAmount)D"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  30 // 원하는 셀 높이
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0 // 헤더 높이 제거
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0 // 푸터 높이 제거
    }

}

