import UIKit

class QuestViewController: UIViewController, UITableViewDelegate {
    // 테이블 뷰 데이터 배열
    // 각 콜렉션 뷰 셀에 해당하는 테이블 뷰의 데이터
    let tableData: [[String]] = [
        ["Item 1", "Item 2", "Item 3"], // 첫 번째 셀에 표시할 데이터
        ["Item A", "Item B", "Item C"], // 두 번째 셀에 표시할 데이터
        ["Item X", "Item Y", "Item Z"]  // 세 번째 셀에 표시할 데이터
    ]
    
    let collectionData = ["1주차","2주차","3주차","4주차"]
    var collectionView2:UICollectionView!
    var tableView:UITableView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<TabBarSection, String>
    
    enum TabBarSection {
        case main
    }
    
    
    private let topTabBar = QuestTabViewController()
    private var dataSource: DataSource! = nil
    
    var currentIndexPath = IndexPath() {
        didSet {
            if currentIndexPath.row == 0 {
                basicView.backgroundColor = UIColor(hex: "#fff8f8")
            } else if currentIndexPath.row == 1 {
                basicView.backgroundColor = .white
            }
        }
    }
    
    var basicView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var mainStackView = setAllViews()
        // 부모 뷰에 큰 스택뷰 추가
        view.addSubview(mainStackView)
        
        // 레이아웃 제약 설정
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTabBar.collectionView.delegate = self
        collectionView2?.dataSource=self
        collectionView2?.delegate=self
        tableView?.dataSource=self
        tableView?.delegate=self
        
        view.addSubview(topTabBar)
        view.addSubview(basicView)
        
        NSLayoutConstraint.activate([
            self.basicView.topAnchor.constraint(equalTo: topTabBar.bottomAnchor, constant: 5),
            self.basicView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.basicView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.basicView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.topTabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.topTabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.topTabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.topTabBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
        
        configureDataSource()
        
        var initalSnapshot = NSDiffableDataSourceSnapshot<TabBarSection, String>()
        initalSnapshot.appendSections([.main])
        initalSnapshot.appendItems(["달성통계", "월별내역"], toSection: .main)
        self.dataSource.apply(initalSnapshot)
        
        let startIndexPath = IndexPath(row: 0, section: 0)
        self.topTabBar.collectionView.selectItem(at: startIndexPath, animated: false, scrollPosition: .init())
        self.currentIndexPath = startIndexPath
    }
    
    func configureDataSource() {
        // Optional 바인딩 대신 직접 사용
        if #available(iOS 14.0, *) {
            // DataSource 초기화
            let cellRegistration = UICollectionView.CellRegistration<QuestTabCell, String> { cell, indexPath, itemIdentifier in
                cell.setTitle(itemIdentifier)
            }
            
            self.dataSource = DataSource(collectionView: topTabBar.collectionView) { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            }
        } else {
            // iOS 14 미만 대응
            //            self.topTabBar.collectionView.register(QuestTabCell.self, forCellWithReuseIdentifier: "QuestTabCell")
            //
            //            self.dataSource = UICollectionViewDiffableDataSource<TabBarSection, String>(collectionView: topTabBar.collectionView) { collectionView, indexPath, itemIdentifier in
            //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestTabCell", for: indexPath) as? QuestTabCell
            //                cell?.setTitle(itemIdentifier)
            //                return cell
            //            }
        }
    }
    
    func updateBasicView(for indexPath: IndexPath) {
        // 기본 뷰를 비우고 새로운 뷰를 추가
        basicView.removeFromSuperview()
        // 새로운 basicView를 생성
        let newBasicView = UIScrollView()
        newBasicView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newBasicView)
        
        
        if indexPath.row == 0 {
            // 첫 번째 뷰 설정
            let newView = setAllViews()
            newBasicView.addSubview(newView)
            
            // 레이아웃 제약 설정
            NSLayoutConstraint.activate([
                newView.topAnchor.constraint(equalTo: topTabBar.bottomAnchor, constant: 20),
                newView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                newView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                newView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            ])
            
            
            
        } else if indexPath.row == 1 {
            // 두 번째 뷰 설정
            let newView = setAllSecondView()
            newBasicView.addSubview(newView)
        }
        
        // 기존 basicView를 새로운 basicView로 교체
        basicView = newBasicView
        NSLayoutConstraint.activate([
            basicView.topAnchor.constraint(equalTo: topTabBar.bottomAnchor, constant: 5),
            basicView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            basicView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    
    // 월별내역
    func setAllSecondView() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1. 콜렉션 뷰 생성
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView2.translatesAutoresizingMaskIntoConstraints = false
        print("월별내역")
        collectionView2.dataSource = self
        collectionView2.delegate = self
        collectionView2.reloadData()
        
        //        collectionView2 = cView2
        // 콜렉션 뷰의 데이터 소스 및 델리게이트 설정
        containerView.addSubview(collectionView2)
        
        collectionView2.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        NSLayoutConstraint.activate([
            collectionView2.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView2.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        
        return containerView
    }
    
    
    
}



func setAllViews() -> UIStackView{
    // 큰 스택뷰 생성 (세 개의 뷰를 세로로 배치)
    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.alignment = .fill
    
    let firstView = setFirstView()
    let secondView = setSecondView()
    let thirdView = setThirdView()
    
    // 스택뷰에 UIView들 추가
    mainStackView.addArrangedSubview(firstView)
    mainStackView.addArrangedSubview(secondView)
    mainStackView.addArrangedSubview(thirdView)
    
    return mainStackView
}


extension QuestViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        print("indexPath")
        updateBasicView(for: indexPath)  // 인덱스에 따라 뷰를 업데이트
    }
    
    // 콜렉션 뷰의 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionData", collectionData.count)
        return 4
    }
    
    // 콜렉션 뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("나 셀이야")
//        let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        
//        // 각 셀에 테이블 뷰를 추가
//        tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        cell.contentView.addSubview(tableView)
//        
//        // 테이블 뷰의 데이터 소스 설정
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        // 테이블 뷰 제약 조건 설정
////        if let cell = cell {
//            NSLayoutConstraint.activate([
//                tableView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
//                tableView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
//                tableView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
//                tableView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
//            ])
//            
//            // 테이블 뷰의 데이터를 설정 (2차원 배열 기반)
//            tableView.tag = indexPath.row // 셀의 indexPath로 데이터를 분리
//            tableView.reloadData()
//            return cell
//        }
//        
        return   UICollectionViewCell()
    }
    
    
}

// 테이블 뷰의 데이터 소스
extension QuestViewController: UITableViewDataSource {
    // 각 셀의 행 수는 2차원 배열의 첫 번째 차원 크기
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // collection view에서 선택된 셀에 맞는 데이터 배열을 가져옵니다.
        // guard let indexPath = tableView.indexPath(for: tableView) else { return 0 }
        return tableData[section].count // 해당 행에 맞는 데이터 갯수
    }
    
    // 각 셀에 데이터 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        // 2차원 배열에서 데이터 가져오기
        let rowData = tableData[indexPath.section] // 섹션에 맞는 데이터를 가져옵니다.
        cell.textLabel?.text = rowData[indexPath.row] // 각 행에 맞는 데이터
        
        return cell
    }
}



func setFirstView() -> UIView{
    // 1. UIView 배경, 테두리, 레이디우스 설정
    let firstView = UIView()
    firstView.translatesAutoresizingMaskIntoConstraints = false
    firstView.backgroundColor = .white
    firstView.layer.borderWidth = 1
    firstView.layer.borderColor = UIColor(hex: "#eaeaea").cgColor
    firstView.layer.cornerRadius = 40
    
    // 글씨와 아이콘을 담을 수평 스택뷰
    let firstStackView = UIStackView()
    firstStackView.translatesAutoresizingMaskIntoConstraints = false
    firstStackView.axis = .horizontal
    firstStackView.spacing = 8
    firstStackView.alignment = .center
    firstStackView.distribution = .fillProportionally  // 글씨는 왼쪽, 아이콘은 오른쪽에 배치됨
    
    // 아이콘 (예시로 시스템 아이콘 사용)
    let iconImageView = UIImageView(image: UIImage(systemName: "star"))
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.tintColor = .black
    
    // 글씨를 세로로 두 줄로 배치하는 StackView
    let textStackView = UIStackView()
    textStackView.translatesAutoresizingMaskIntoConstraints = false
    textStackView.axis = .vertical
    textStackView.spacing = 5
    textStackView.alignment = .center  // 글씨는 가운데 정렬
    
    let label1 = UILabel()
    label1.text = "현재 이서님은"
    label1.numberOfLines = 0 // 텍스트가 줄 바꿈되도록 설정
    label1.textAlignment = .center
    
    let label2 = UILabel()
    label2.text = "3주 연속 도전 중 💪"
    label2.numberOfLines = 0 // 텍스트가 줄 바꿈되도록 설정
    label2.textAlignment = .center
    
    textStackView.addArrangedSubview(label1)
    textStackView.addArrangedSubview(label2)
    
    // 아이콘을 세로로 세 줄로 배치하는 StackView
    let iconStackView = UIStackView()
    iconStackView.translatesAutoresizingMaskIntoConstraints = false
    iconStackView.axis = .vertical
    iconStackView.spacing = 5
    iconStackView.alignment = .center // 아이콘을 오른쪽 정렬
    
    // 아이콘 추가 (예시로 UILabel을 사용, 실제 아이콘은 UIImageView로 변경 가능)
    let icon1 = UILabel()
    icon1.text = "🔴 MAX"
    icon1.font = UIFont.systemFont(ofSize: 15)
    let icon2 = UILabel()
    icon2.text = "🟡 MED"
    icon2.font = UIFont.systemFont(ofSize: 15)
    let icon3 = UILabel()
    icon3.text = "⚫️ 기타"
    icon3.font = UIFont.systemFont(ofSize: 15)
    
    iconStackView.addArrangedSubview(icon1)
    iconStackView.addArrangedSubview(icon2)
    iconStackView.addArrangedSubview(icon3)
    
    // textStackView와 iconStackView를 첫 번째 뷰에 추가
    firstStackView.addSubview(textStackView)
    //    firstStackView.addSubview(iconStackView)
    
    // 하단에 수평 스택뷰 추가 (이미지 7개 배치)
    let imageStackView = UIStackView()
    imageStackView.translatesAutoresizingMaskIntoConstraints = false
    imageStackView.axis = .horizontal
    imageStackView.spacing = 8
    imageStackView.alignment = .center
    
    // 이미지 7개 추가
    for _ in 0..<7 {
        let imageView = UIImageView(image: UIImage(named:"imgChecked"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageStackView.addArrangedSubview(imageView)
        
        // 동일한 크기로 설정
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    // 첫 번째 뷰에 스택뷰 추가
    firstView.addSubview(firstStackView)
    firstView.addSubview(imageStackView)
    
    // 레이아웃 제약 설정
    NSLayoutConstraint.activate([
        // 첫 번째 스택뷰 제약 (수평 중앙 정렬)
        firstStackView.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 10),
        firstStackView.leadingAnchor.constraint(equalTo: firstView.leadingAnchor, constant: 10),
        firstStackView.trailingAnchor.constraint(equalTo: firstView.trailingAnchor, constant: -10),
        
        // 수평 스택뷰 제약
        // 이미지 수평 스택뷰 제약
        imageStackView.topAnchor.constraint(equalTo: firstStackView.bottomAnchor, constant: 10),
        imageStackView.leadingAnchor.constraint(equalTo: firstView.leadingAnchor, constant: 10),
        imageStackView.trailingAnchor.constraint(equalTo: firstView.trailingAnchor, constant: -10),
        imageStackView.bottomAnchor.constraint(equalTo: firstView.bottomAnchor, constant: -10),
    ])
    
    return firstView
}

func setSecondView() -> UIView {
    // 2. UIView 배경, 테두리, 레이디우스 설정
    let secondView = UIView()
    secondView.translatesAutoresizingMaskIntoConstraints = false
    secondView.backgroundColor = .white
    secondView.layer.borderWidth = 1
    secondView.layer.borderColor = UIColor(hex: "#eaeaea").cgColor
    secondView.layer.cornerRadius = 40
    
    // 두 개의 글씨를 가로로 배치할 수 있는 수평 스택뷰
    let secondStackView = UIStackView()
    secondStackView.translatesAutoresizingMaskIntoConstraints = false
    secondStackView.axis = .horizontal
    secondStackView.spacing = 8
    secondStackView.alignment = .center
    
    let temp1 = UIStackView()
    temp1.translatesAutoresizingMaskIntoConstraints = false
    temp1.axis = .vertical
    temp1.spacing = 5
    temp1.alignment = .center
    
    // 첫 번째 글씨
    let label1 = UILabel()
    label1.translatesAutoresizingMaskIntoConstraints = false
    label1.text = "퀘스트 달성률"
    label1.font = UIFont.systemFont(ofSize: 16)
    
    let label11 = UILabel()
    label11.translatesAutoresizingMaskIntoConstraints = false
    label11.text = "91%"
    label11.font = UIFont.systemFont(ofSize: 36)
    
    temp1.addArrangedSubview(label1)
    temp1.addArrangedSubview(label11)
    
    
    // 두 번째 글씨
    let temp2 = UIStackView()
    temp2.translatesAutoresizingMaskIntoConstraints = false
    temp2.axis = .vertical
    temp2.spacing = 5
    temp2.alignment = .center
    
    
    let label2 = UILabel()
    label2.translatesAutoresizingMaskIntoConstraints = false
    label2.text = "최장 달성 기간"
    label2.font = UIFont.systemFont(ofSize: 16)
    
    let label22 = UILabel()
    label22.translatesAutoresizingMaskIntoConstraints = false
    label22.text = "13주🔥"
    label22.font = UIFont.systemFont(ofSize: 36)
    
    temp2.addArrangedSubview(label2)
    temp2.addArrangedSubview(label22)
    
    
    // 두 글씨를 수평 스택뷰에 추가
    secondStackView.addArrangedSubview(temp1)
    secondStackView.addArrangedSubview(temp2)
    
    // 두 번째 뷰에 수평 스택뷰 추가
    secondView.addSubview(secondStackView)
    
    // 레이아웃 제약 설정
    NSLayoutConstraint.activate([
        // 수평 스택뷰 제약 (뷰 내부에 중앙 정렬)
        secondStackView.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 10),
        secondStackView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 10),
        secondStackView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -10),
        secondStackView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -10),
        secondStackView.heightAnchor.constraint(equalToConstant: 100),  // 세로 길이 조정
    ])
    return secondView
}

func setThirdView() -> UIView{
    // 3. 정사각형 UIView 배경, 테두리, 레이디우스 설정
    let thirdView = UIView()
    thirdView.translatesAutoresizingMaskIntoConstraints = false
    thirdView.backgroundColor = .white
    thirdView.layer.borderWidth = 1
    thirdView.layer.borderColor = UIColor(hex: "#eaeaea").cgColor
    thirdView.layer.cornerRadius = 40
    // 제목 라벨 설정
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = "과거 경험치 획득량"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    titleLabel.textAlignment = .left
    titleLabel.numberOfLines = 1
    
    // 제목 라벨을 thirdView에 추가
    thirdView.addSubview(titleLabel)
    
    // 정사각형 모양으로 뷰 크기 설정
    NSLayoutConstraint.activate([
        thirdView.widthAnchor.constraint(equalToConstant: 100),  // 정사각형 너비
        thirdView.heightAnchor.constraint(equalTo: thirdView.widthAnchor),  // 너비와 동일하게 높이 설정
        // 제목 라벨 제약 (thirdView의 상단에 배치)
        titleLabel.topAnchor.constraint(equalTo: thirdView.topAnchor, constant: 10),
        titleLabel.leadingAnchor.constraint(equalTo: thirdView.leadingAnchor, constant: 10),
        titleLabel.trailingAnchor.constraint(equalTo: thirdView.trailingAnchor, constant: -10),
    ])
    return thirdView
}

//import SwiftUI
//
//struct QuestViewControllerPreview: PreviewProvider {
//    static var previews: some View {
//        UIViewControllerPreview {
//            let questVC = QuestViewController()
//            return questVC
//        }
//    }
//}
