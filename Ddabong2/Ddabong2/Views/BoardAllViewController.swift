//
//  BoardAllViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/7/25.
//
import UIKit

class BoardAllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    
    // 임시 데이터 배열
    var data = [
        ("2024년 12월 급여 지급 안내", "23시간 전"),
        ("2024년 12월 4주차 주간회의 공지", "2024.12.30"),
        ("12월 3일 소방 훈련 관련 안내", "2024.12.02"),
        ("공모전 공지", "2024.11.29"),
        ("두핸즈와의 계약건에 관한 공지", "2024.11.13")
    ]

    
    
    // UI 요소들
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시판"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력하세요."
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return textField
    }()

    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(hex: "#FF5B35")
        button.layer.cornerRadius = 8
        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        tableView.dataSource = self
        tableView.delegate = self

        // UI 구성
        setupUI()
    }

    func setupUI() {
        // 상단 타이틀 추가
        view.addSubview(titleLabel)

        // 검색창과 버튼 StackView
        let searchStack = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        searchStack.axis = .horizontal
        searchStack.spacing = 8
        searchStack.distribution = .fill

        // StackView 및 TableView 추가
        view.addSubview(searchStack)
        view.addSubview(tableView)

        // AutoLayout 설정
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchStack.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 상단 타이틀
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // 검색 StackView
            searchStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchStack.heightAnchor.constraint(equalToConstant: 40),

            // 검색 버튼 크기 고정
            searchButton.widthAnchor.constraint(equalToConstant: 60),

            // TableView
            tableView.topAnchor.constraint(equalTo: searchStack.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = data[indexPath.row]

        // 텍스트 구성
        let title = item.0
        let date = item.1

        let attributedText = NSMutableAttributedString(
            string: title + "\n",
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)]
        )
        attributedText.append(NSAttributedString(
            string: date,
            attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor(hex: "#FF5B35")]
        ))

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = attributedText
        return cell
    }
}



//프리뷰~~
import SwiftUI

struct BoardAllViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let viewController = BoardAllViewController()
            return viewController
        }
        .edgesIgnoringSafeArea(.all)
    }
}
