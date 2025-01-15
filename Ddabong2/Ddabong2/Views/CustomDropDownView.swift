//
//  CustomDropDownView.swift
//  Ddabong2
//
//  Created by 안지희 on 1/15/25.
//


import UIKit

class CustomDropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private var items: [String] = []
    private var onSelect: ((String) -> Void)?

    init(items: [String], frame: CGRect, onSelect: @escaping (String) -> Void) {
        self.items = items
        self.onSelect = onSelect
        super.init(frame: frame)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)

        // 셀의 레이아웃 마진 설정
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)

        return cell
    }




    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        onSelect?(selectedItem)
        self.removeFromSuperview()
    }
}
