import UIKit

class BoardTableViewCell: UITableViewCell {
    static let identifier = "BoardTableViewCell"

    private let newIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "newboard") // newboard 이미지
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // 기본적으로 숨김
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#FF8C72")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right") // 오른쪽 화살표 아이콘
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(newIconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(arrowImageView)

        NSLayoutConstraint.activate([
            newIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            newIconImageView.widthAnchor.constraint(equalToConstant: 16),
            newIconImageView.heightAnchor.constraint(equalToConstant: 16),

            titleLabel.leadingAnchor.constraint(equalTo: newIconImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),

            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with board: Board) {
        titleLabel.text = board.title
        timeLabel.text = formatRelativeTime(board.timeAgo)
        
        // 24시간 이내에 작성된 글인지 확인하여 newboard 이미지 표시 설정
        if isWithinLast24Hours(board.timeAgo) {
            newIconImageView.isHidden = false
        } else {
            newIconImageView.isHidden = true
        }
    }

    private func formatRelativeTime(_ timeAgo: String) -> String {
        // 서버에서 상대적인 시간("2분 전", "5시간 전" 등)으로 제공되므로 그대로 사용
        return timeAgo
    }

    private func isWithinLast24Hours(_ timeAgo: String) -> Bool {
        print("timeAgo: \(timeAgo)") // 입력값 확인

        if timeAgo.contains("분 전") {
            if let value = Int(timeAgo.replacingOccurrences(of: "분 전", with: "").trimmingCharacters(in: .whitespaces)) {
                print("\(value)분 전: \(value < 1440 ? "24시간 이내" : "24시간 초과")")
                return value < 1440
            }
        } else if timeAgo.contains("시간 전") {
            if let value = Int(timeAgo.replacingOccurrences(of: "시간 전", with: "").trimmingCharacters(in: .whitespaces)) {
                print("\(value)시간 전: \(value < 24 ? "24시간 이내" : "24시간 초과")")
                return value < 24
            }
        }

        print("24시간 초과 또는 형식 불일치")
        return false
    }


}

