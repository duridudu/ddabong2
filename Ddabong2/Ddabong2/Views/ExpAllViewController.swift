//
//  ExpAllViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/11/25.
//

import Foundation
import UIKit

class ExpAllViewController:UIViewController,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    let viewModel = ExpViewModel()
    var responseDTO: ExpResponse?

    @IBOutlet weak var btnBack: UIButton!
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        fetchAllExps(page:0, size:15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData() // 데이터 로드 후 테이블 뷰 새로 고침
        // ViewModel의 데이터 변경 감지
        viewModel.onResponseDtoUpdated = { [weak self] dto in
            guard let self = self, let dto = dto else { return }
            self.responseDTO = dto
            DispatchQueue.main.async {
                self.updateUI() // UI 업데이트 함수 호출
            }
        }
        
        fetchAllExps(page:0, size:15)
        
    }
    

    func fetchAllExps(page: Int, size: Int) {
        viewModel.fetchAllExps(page: page, size: size)
    }
    
    func updateUI() {
        // responseDTO를 기반으로 UI 업데이트
        print("UI 업데이트: \(String(describing: responseDTO))")
        
        
        tableView.isScrollEnabled = false
        
        // 테이블 뷰 스타일
        tableView.layer.cornerRadius = 12 // 둥근 모서리 적용
        tableView.layer.masksToBounds = true // 둥근 모서리가 잘리도록 설정
        
        // 테이블 뷰 줄 제거
        tableView.separatorStyle = .none
        
        self.tableView.reloadData() // 테이블 뷰 갱신
    }
}


extension ExpAllViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("경험치 카운트" , responseDTO?.quests.count ?? 0)
        return responseDTO?.quests.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpCell", for: indexPath) as! ExpCell
        let quest = responseDTO?.quests[indexPath.row] ?? Exp.defaultExp

       // cell.backgroundColor = UIColor(hex: "fff8f8") // 원하는 배경색 (예: 밝은 베이지)
        
        // 선택 시 배경색 제거
        let bgView = UIView()
        bgView.backgroundColor = .clear
        cell.selectedBackgroundView = bgView
        
       cell.configure(with: quest)
        return cell
    }
    
}


