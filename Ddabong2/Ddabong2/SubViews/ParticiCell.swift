//
//  ParticiCell.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/29/24.
//

import Foundation
import UIKit
class ParticiCell:UITableViewCell{
    
   
    @IBOutlet weak var lblMember: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupCell()
        }
    
   
    
    // 스토리보드나 XIB에서 사용하려면 init(coder:)를 구현해야 함
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupCell()
       }
    
        
        private func setupCell() {
            // 셀의 UI 설정
            self.textLabel?.textColor = .black
        }
}
