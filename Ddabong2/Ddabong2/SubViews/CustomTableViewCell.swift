//
//  CustomTableViewCell.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/13/25.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
