//
//  ExpCell.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/15/25.
//

import UIKit
class ExpCell:UITableViewCell{
    
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblBg: UILabel!
    
    func configure(with quest: Exp) {
        print("난 셀이야", quest)
        lblBg.layer.cornerRadius = 8
        lblExp.text = "\(quest.expAmount)D"
        lblTime.text = "\(quest.completedAt)"
//        lblContent.text = "\(quest.)"
        lblTitle.text = quest.name
    }
}
