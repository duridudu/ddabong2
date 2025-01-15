import UIKit

class ChangeProfileViewController: UIViewController {
    
    private let userInfoViewModel = UserInfoViewModel()
    // MARK: - Properties
    private var selectedAvatarId: Int? // 선택된 프로필 ID
    private let avatarImages: [UIImage] = (1...9).compactMap { UIImage.profileImage(for: $0) }
    
    // MARK: - UI Components
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 1.0, green: 0.357, blue: 0.208, alpha: 1.0) // #FF5B35
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50 // 반지름을 이미지뷰의 절반으로 설정 (100x100 크기 기준)
        imageView.layer.borderWidth = 2 // 테두리 두께
        imageView.layer.borderColor = UIColor.lightGray.cgColor // 연한 회색 테두리 색상
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemOrange
        label.textAlignment = .center
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "사용할 프로필을 선택해주세요"
        label.textAlignment = .center
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let avatarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = spacing * 4 // 좌우 여백 + 셀 간 간격
        let itemWidth = (screenWidth - totalSpacing) / 3 - 10 // 크기 줄임

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 16, left: spacing, bottom: 16, right: spacing)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        avatarCollectionView.delegate = self
        avatarCollectionView.dataSource = self
        avatarCollectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "AvatarCell")
        setupInitialProfile()
        navigationItem.hidesBackButton = true // 파란색 뒤로가기 버튼 숨기기
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(saveButton)
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(instructionLabel)
        view.addSubview(separatorView)
        view.addSubview(avatarCollectionView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        avatarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 32),
            
            profileImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            instructionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            separatorView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            avatarCollectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            avatarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            avatarCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Initial Setup
    private func setupInitialProfile() {
        guard let user = UserSessionManager.shared.getUserInfo() else { return }
        profileImageView.image = UIImage.profileImage(for: user.avartaId)
        userNameLabel.text = "\(user.name)님"
        selectedAvatarId = user.avartaId
    }
    
    // MARK: - Handlers
    @objc private func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleSaveButton() {
        guard let avatarId = selectedAvatarId else {
            let alert = UIAlertController(title: "오류", message: "프로필 이미지를 선택해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        ProfileService.shared.updateProfileImage(avatarId: avatarId) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.showProfileChangeModal() // 모달 표시
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "오류", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - Show Modal
    private func showProfileChangeModal() {
        let modalVC = ProfileChangeModalViewController()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.onConfirm = {
            // 확인 버튼 클릭 후 처리
            self.navigationController?.popViewController(animated: true)
        }
        present(modalVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ChangeProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        cell.configure(image: UIImage.profileImage(for: indexPath.item + 1) ?? UIImage(), isSelected: indexPath.item + 1 == selectedAvatarId)
        cell.layer.cornerRadius = cell.frame.width / 2 // Circular Image
        cell.layer.borderWidth = 2 // 테두리 두께
        cell.layer.borderColor = UIColor.lightGray.cgColor // 연한 회색 테두리
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatarId = indexPath.item + 1
        profileImageView.image = UIImage.profileImage(for: selectedAvatarId!)
        collectionView.reloadData()
    }
}
