//
//  RankingViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//


import UIKit

class RankingViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = RankingViewModel()

    private let departmentNames = [
        1: "음성 1센터",
        2: "음성 2센터",
        3: "용인백암센터",
        4: "남양주센터",
        5: "파주센터",
        6: "사업기획팀",
        7: "그로스팀",
        8: "CX팀"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchRankings()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "팀 랭킹"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RankingCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel.onRankingsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension RankingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRankings().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath)
        let rank = viewModel.getRankings()[indexPath.row]
        let departmentName = departmentNames[rank.departmentId] ?? "Unknown Department"
        cell.textLabel?.text = "\(rank.rank). \(departmentName) - \(rank.expAvg) do"
        return cell
    }
}
