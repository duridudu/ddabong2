//
//  UserTableViewCell.swift
//  Ddabong2
//
//  Created by 안지희 on 1/14/25.
//


import UIKit

class UserTableViewCell: UITableViewCell {
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true

        nameLabel.font = .boldSystemFont(ofSize: 16)
        detailsLabel.font = .systemFont(ofSize: 14)
        detailsLabel.textColor = .gray

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            detailsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with user: User) {
        avatarImageView.image = UIImage(named: "avatar\(user.avartaId)")
        nameLabel.text = "\(user.name) [\(user.employeeNum)]"
        detailsLabel.text = "\(user.department) / \(user.level)"
    }
}
