//
//  MyPageViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 12/25/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // Greeting Section
    private let greetingCardView = UIView()
    private let greetingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ddabong2") // Replace with your actual image name
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "최이서님, 안녕하세요!"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "01월 08일 오늘의 운세\n놓치지 말고 도전!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "F1-II 10500"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = UIColor.systemRed
        progress.trackTintColor = UIColor.systemGray5
        progress.progress = 0.78
        return progress
    }()
    
    private let progressSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "F2-1 승급까지 -3000"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    // Experience Section
    private let experienceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "경험치 현황"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let recentQuestLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 획득 경험치"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let recentQuestValueLabel: UILabel = {
        let label = UILabel()
        label.text = "직무별 퀘스트\n생산성 MAX 달성"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    private let experienceProgressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = UIColor.systemOrange
        progress.trackTintColor = UIColor.systemGray5
        progress.progress = 0.83
        return progress
    }()
    
    private let experienceYearLabel: UILabel = {
        let label = UILabel()
        label.text = "올해 획득한 경험치 7,500"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let experienceLastYearLabel: UILabel = {
        let label = UILabel()
        label.text = "작년에 획득한 경험치 3,000"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        edgesForExtendedLayout = []
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupScrollView()
        setupHeader()
        setupGreetingCard()
        setupExperienceSection()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupHeader() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(notificationButton)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            notificationButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupGreetingCard() {
        contentView.addSubview(greetingCardView)
        greetingCardView.translatesAutoresizingMaskIntoConstraints = false
        greetingCardView.layer.cornerRadius = 12
        greetingCardView.backgroundColor = .white
        greetingCardView.layer.shadowColor = UIColor.black.cgColor
        greetingCardView.layer.shadowOpacity = 0.1
        greetingCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        greetingCardView.layer.shadowRadius = 4
        
        greetingCardView.addSubview(greetingImageView)
        greetingCardView.addSubview(greetingLabel)
        greetingCardView.addSubview(dateLabel)
        greetingCardView.addSubview(progressLabel)
        greetingCardView.addSubview(progressView)
        greetingCardView.addSubview(progressSubtitleLabel)
        
        greetingImageView.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            greetingCardView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            greetingCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            greetingCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            greetingCardView.heightAnchor.constraint(equalToConstant: 140),
            
            greetingImageView.leadingAnchor.constraint(equalTo: greetingCardView.leadingAnchor, constant: 16),
            greetingImageView.centerYAnchor.constraint(equalTo: greetingCardView.centerYAnchor),
            greetingImageView.widthAnchor.constraint(equalToConstant: 60),
            greetingImageView.heightAnchor.constraint(equalToConstant: 60),
            
            greetingLabel.topAnchor.constraint(equalTo: greetingCardView.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: greetingImageView.trailingAnchor, constant: 16),
            
            dateLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: greetingImageView.trailingAnchor, constant: 16),
            
            progressLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            progressLabel.leadingAnchor.constraint(equalTo: greetingCardView.leadingAnchor, constant: 16),
            
            progressView.centerYAnchor.constraint(equalTo: progressLabel.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: progressLabel.trailingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: greetingCardView.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            progressSubtitleLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressSubtitleLabel.trailingAnchor.constraint(equalTo: greetingCardView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupExperienceSection() {
        contentView.addSubview(experienceTitleLabel)
        contentView.addSubview(recentQuestLabel)
        contentView.addSubview(recentQuestValueLabel)
        contentView.addSubview(experienceProgressView)
        contentView.addSubview(experienceYearLabel)
        contentView.addSubview(experienceLastYearLabel)
        
        experienceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recentQuestLabel.translatesAutoresizingMaskIntoConstraints = false
        recentQuestValueLabel.translatesAutoresizingMaskIntoConstraints = false
        experienceProgressView.translatesAutoresizingMaskIntoConstraints = false
        experienceYearLabel.translatesAutoresizingMaskIntoConstraints = false
        experienceLastYearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            experienceTitleLabel.topAnchor.constraint(equalTo: greetingCardView.bottomAnchor, constant: 32),
            experienceTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            recentQuestLabel.topAnchor.constraint(equalTo: experienceTitleLabel.bottomAnchor, constant: 16),
            recentQuestLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            recentQuestValueLabel.topAnchor.constraint(equalTo: recentQuestLabel.bottomAnchor, constant: 8),
            recentQuestValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            experienceProgressView.topAnchor.constraint(equalTo: recentQuestValueLabel.bottomAnchor, constant: 16),
            experienceProgressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            experienceProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            experienceProgressView.heightAnchor.constraint(equalToConstant: 4),
            
            experienceYearLabel.topAnchor.constraint(equalTo: experienceProgressView.bottomAnchor, constant: 16),
            experienceYearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            experienceLastYearLabel.topAnchor.constraint(equalTo: experienceYearLabel.bottomAnchor, constant: 8),
            experienceLastYearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            experienceLastYearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

}
