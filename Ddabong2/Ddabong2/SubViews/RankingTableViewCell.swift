import UIKit

class RankingTableViewCell: UITableViewCell {

    private let rankLabel = UILabel()
    private let rankImageView = UIImageView()
    private let departmentLabel = UILabel()
    private let scoreLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .bar)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        rankLabel.font = UIFont.boldSystemFont(ofSize: 16)
        rankLabel.textAlignment = .center
        rankLabel.textColor = .black

        rankImageView.contentMode = .scaleAspectFit

        departmentLabel.font = UIFont.systemFont(ofSize: 14)
        departmentLabel.textColor = .black

        scoreLabel.font = UIFont.systemFont(ofSize: 14)
        scoreLabel.textColor = UIColor(red: 1.0, green: 0.36, blue: 0.21, alpha: 1.0) // FF5B35
        scoreLabel.textAlignment = .right

        progressBar.trackTintColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1.0) // E4E4E4
        progressBar.progressTintColor = UIColor(red: 1.0, green: 0.44, blue: 0.31, alpha: 1.0) // FF704F
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true

        let rankContainer = UIView()
        rankContainer.addSubview(rankLabel)
        rankContainer.addSubview(rankImageView)

        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankLabel.centerXAnchor.constraint(equalTo: rankContainer.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankContainer.centerYAnchor),

            rankImageView.centerXAnchor.constraint(equalTo: rankContainer.centerXAnchor),
            rankImageView.centerYAnchor.constraint(equalTo: rankContainer.centerYAnchor),
            rankImageView.widthAnchor.constraint(equalToConstant: 24),
            rankImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        let containerStackView = UIStackView(arrangedSubviews: [rankContainer, departmentLabel, scoreLabel])
        containerStackView.axis = .horizontal
        containerStackView.spacing = 8
        containerStackView.alignment = .center

        contentView.addSubview(containerStackView)
        contentView.addSubview(progressBar)

        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rankContainer.widthAnchor.constraint(equalToConstant: 40),
            rankContainer.heightAnchor.constraint(equalToConstant: 40),

            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            progressBar.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 10), // 그래프 두께 조정
            progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(rank: Int, department: String, score: Int) {
        // 랭크에 따라 이미지 또는 숫자 표시
        if rank == 1 {
            rankImageView.image = UIImage(named: "rank1")
            rankLabel.isHidden = true
        } else if rank == 2 {
            rankImageView.image = UIImage(named: "rank2")
            rankLabel.isHidden = true
        } else if rank == 3 {
            rankImageView.image = UIImage(named: "rank3")
            rankLabel.isHidden = true
        } else {
            rankImageView.image = nil
            rankLabel.isHidden = false
            rankLabel.text = "\(rank)"
        }

        departmentLabel.text = department
        scoreLabel.text = "\(score) do"
        progressBar.progress = Float(score) / 200.0 // 최대 점수를 200으로 설정
    }
}

