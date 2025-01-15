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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
                self.updateOlds()
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
       
    }
    
    func updateOlds(){
        print("UI 업데이트: old tables", String(describing: responseDTO?.oldAlarmList))
        self.oldTableView.reloadData()
    }
}

extension AlarmViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentTableView {
            print("RECENT",  responseDTO?.recentAlarmList.count ?? 0)
            return responseDTO?.recentAlarmList.count ?? 0
        } else if tableView == oldTableView {
            print("OLD",  responseDTO?.oldAlarmList.count ?? 0)
            return responseDTO?.oldAlarmList.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("현재 tableView: \(tableView)")
        if tableView == recentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentAlarmCell", for: indexPath) as! RecentAlarmCell
            let alarm = responseDTO?.recentAlarmList[indexPath.row] ?? Alarm.defaultAlarm
            print("RECENTVIEW")
            // 셀 구성 (예: 제목과 생성일 표시)
            cell.configure(with: alarm)
            return cell
        } else if tableView == oldTableView {
            print("OLDTABLEVIEW")
            let cell = tableView.dequeueReusableCell(withIdentifier: "OldAlarmsCell", for: indexPath) as! OldAlarmsCell
            let alarm = responseDTO?.oldAlarmList[indexPath.row] ?? Alarm.defaultAlarm
            // 셀 구성 (예: 제목과 생성일 표시)
            cell.configure(with: alarm)
            return cell
        }
        
        print("테이블이 매칭되지 않음")
        return UITableViewCell()
    }
}
