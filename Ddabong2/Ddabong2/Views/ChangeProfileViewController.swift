import UIKit

class ChangeProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedAvatarId: Int? // 선택된 프로필 ID
    private let avatarImages: [UIImage] = [
        UIImage(named: "avatar1") ?? UIImage(),
        UIImage(named: "avatar2") ?? UIImage(),
        UIImage(named: "avatar3") ?? UIImage(),
        UIImage(named: "avatar4") ?? UIImage(),
        UIImage(named: "avatar5") ?? UIImage(),
        UIImage(named: "avatar6") ?? UIImage(),
        UIImage(named: "avatar7") ?? UIImage(),
        UIImage(named: "avatar8") ?? UIImage(),
        UIImage(named: "avatar9") ?? UIImage()
    ]
    
    // MARK: - UI Components
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemOrange.cgColor
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
        let spacing: CGFloat = 12 // 셀 간의 간격
        let screenWidth = UIScreen.main.bounds.width // 화면 너비
        let totalSpacing = spacing * 4 // 좌우 여백 + 셀 간 간격
        let itemWidth = (screenWidth - totalSpacing) / 3 // 3개의 셀 + 여백 간격

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // 정사각형 셀
        layout.minimumInteritemSpacing = spacing // 가로 간격
        layout.minimumLineSpacing = spacing // 세로 간격
        layout.sectionInset = UIEdgeInsets(top: 12, left: spacing, bottom: 12, right: spacing) // 상하좌우 여백
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
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
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(instructionLabel)
        view.addSubview(separatorView)
        view.addSubview(avatarCollectionView)
        view.addSubview(saveButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        avatarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            instructionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            avatarCollectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            avatarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            avatarCollectionView.heightAnchor.constraint(equalToConstant: 320),
            
            saveButton.topAnchor.constraint(equalTo: avatarCollectionView.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Initial Setup
    private func setupInitialProfile() {
        guard let user = UserSessionManager.shared.getUserInfo() else { return }
        profileImageView.image = avatarImages[user.avartaId - 1]
        userNameLabel.text = "\(user.name)님"
        selectedAvatarId = user.avartaId // 초기값으로 사용자 아바타 ID 설정
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
                    let alert = UIAlertController(title: "완료", message: "프로필 이미지가 성공적으로 업데이트되었습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(alert, animated: true)
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
}

// MARK: - UICollectionView Delegate & DataSource
extension ChangeProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        cell.configure(image: avatarImages[indexPath.item], isSelected: indexPath.item + 1 == selectedAvatarId)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatarId = indexPath.item + 1
        collectionView.reloadData()
    }
}

// MARK: - AvatarCell
class AvatarCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let overlayView = UIView()
    private let checkmarkImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(checkmarkImageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkmarkImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.isHidden = true
        
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.tintColor = .white
        checkmarkImageView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, isSelected: Bool) {
        imageView.image = image
        overlayView.isHidden = !isSelected
        checkmarkImageView.isHidden = !isSelected
    }
}
