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
        print("난 셀 설정 함수야", quest.name)
        //cell.lblTitle.text = quest.name
       cell.configure(with: quest)
        return cell
    }
    
}


