//
//  AlarmViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/15/25.
//

import UIKit
class AlarmViewController:UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var oldTableView: UITableView!
    @IBOutlet weak var recentTableView: UITableView!
    
    let viewModel = AlarmViewModel()
    var responseDTO: AlarmResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentTableView.dataSource = self
        recentTableView.delegate = self
        recentTableView.reloadData() // 데이터 로드 후 테이블 뷰 새로 고침
        
        oldTableView.dataSource = self
        oldTableView.delegate = self
        oldTableView.reloadData() // 데이터 로드 후 테이블 뷰 새로 고침
        
        // ViewModel의 데이터 변경 감지
        viewModel.onResponseDtoUpdated = { [weak self] dto in
            guard let self = self, let dto = dto else { return }
            self.responseDTO = dto
            DispatchQueue.main.async {
                self.updateUI() // UI 업데이트 함수 호출
            }
        }
        fetchAllAlarms()
        
    }
    
    func fetchAllAlarms() {
        viewModel.fetchAllAlarms()
    }
    
    func updateUI() {
        // responseDTO를 기반으로 UI 업데이트
        print("UI 업데이트: \(String(describing: responseDTO))")
        self.recentTableView.reloadData() // 테이블 뷰 갱신
        self.oldTableView.reloadData()
    }
    
    
}

extension AlarmViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentTableView {
            return responseDTO?.recentAlarmList.count ?? 0
        } else if tableView == oldTableView {
            return responseDTO?.oldAlarmList.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentAlarmCell", for: indexPath)
            let alarm = responseDTO?.recentAlarmList[indexPath.row]
            // 셀 구성 (예: 제목과 생성일 표시)
            cell.textLabel?.text = alarm?.title
            cell.detailTextLabel?.text = alarm?.createdAt
            return cell
        } else if tableView == oldTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OldAlarmCell", for: indexPath)
            let alarm = responseDTO?.oldAlarmList[indexPath.row]
            // 셀 구성 (예: 제목과 생성일 표시)
            cell.textLabel?.text = alarm?.title
            cell.detailTextLabel?.text = alarm?.createdAt
            return cell
        }
        
        return UITableViewCell()
    }
}
