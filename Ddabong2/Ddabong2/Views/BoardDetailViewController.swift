//
//  BoardDetailViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/7/25.
//


import UIKit

class BoardDetailViewController: UIViewController {
    var boardId: Int?

    private let titleLabel = UILabel()
    private let createdAtLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchBoardDetails()
    }

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.font = UIFont.systemFont(ofSize: 14)
        createdAtLabel.textAlignment = .center
        createdAtLabel.textColor = .gray

        view.addSubview(titleLabel)
        view.addSubview(createdAtLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            createdAtLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            createdAtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func fetchBoardDetails() {
        guard let boardId = boardId else { return }

        // 임시 데이터: ViewModel에서 검색
        if let board = BoardViewModel().boards.first(where: { $0.boardId == boardId }) {
            titleLabel.text = board.title
            createdAtLabel.text = "작성일: \(board.createdAt)"
        } else {
            titleLabel.text = "게시글을 찾을 수 없습니다."
            createdAtLabel.text = nil
        }
    }
}
