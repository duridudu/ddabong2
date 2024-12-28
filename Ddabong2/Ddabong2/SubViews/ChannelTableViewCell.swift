//
//  ChannelTableViewCell.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/28/24.
//



import UIKit


class ChannelTableViewCell: UITableViewCell {
    lazy var chatRoomLabel: UILabel = {
        let label = UILabel()
       // label.textColor = .primary
        return label
    }()
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        contentView.addSubview(chatRoomLabel)
        contentView.addSubview(detailButton)
        
        chatRoomLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(detailButton).offset(-24)
        }
        
        detailButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
        }
    }
}
