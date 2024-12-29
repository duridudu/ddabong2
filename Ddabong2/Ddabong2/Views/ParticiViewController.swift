//
//  ParticiViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/29/24.
//

import Foundation
import UIKit
class ParticiViewController:UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var particiList: UITableView!
    
    override func viewDidLoad() {
        // 테이블 델리게이트 설정
        setupTableView()
        
    }
    
    // 테이블 뷰 설정
    func setupTableView() {
       // tableView = chatList
        particiList.dataSource = self
        particiList.delegate = self
        particiList.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: -버튼 클릭 이벤트
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // "Main"은 스토리보드 파일 이름
        let roomVC = storyboard.instantiateViewController(withIdentifier: "roomNameVC")
      //  navigationController?.pushViewController(chatVC, animated: true)
        self.navigationController?.pushViewController(roomVC, animated: true)
    
    }
}

