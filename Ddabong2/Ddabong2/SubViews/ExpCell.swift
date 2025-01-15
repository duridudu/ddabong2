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
    
    
    func configure(with quest: Exp) {
        print("난 셀이야", quest)
        lblExp.text = "\(quest.expAmount)D"
        lblTime.text = "\(quest.completedAt) 전"
//        lblContent.text = "\(exp.)"
        lblTitle.text = quest.name
    }
}
