//
//  RecentAlarmCell.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/15/25.
//

import UIKit
class RecentAlarmCell:UITableViewCell{
    
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBg: UILabel!
    
    func configure(with noti: Alarm) {
        lblContent.text = noti.title
        lblTime.text = noti.createdAt
        lblTitle.text = noti.title
    }
}
