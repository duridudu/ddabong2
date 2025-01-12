//
//  NavigationBarViewController.swift
//  Ddabong2
//
//  Created by 안지희 on 1/8/25.
//

import Foundation
import UIKit

class NavigationViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 각 뷰 컨트롤러 초기화
        let myPageVC = MyPageViewController()
        //let questVC = QuestViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questVC = storyboard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController

        let raceVC = RaceViewController()
        let boardVC = BoardViewController()
        
        // 각 뷰 컨트롤러의 탭 바 항목 설정
        myPageVC.tabBarItem = UITabBarItem(title: "MY", image: UIImage(named: "nvmypage_b"), selectedImage: nil)
        questVC.tabBarItem = UITabBarItem(title: "퀘스트", image: UIImage(named: "nbstar_b"), selectedImage: nil)
        raceVC.tabBarItem = UITabBarItem(title: "레이스", image: UIImage(named: "nvrace_b"), selectedImage: nil)
        boardVC.tabBarItem = UITabBarItem(title: "게시판", image: UIImage(named: "nvboard_b"), selectedImage: nil)
        
        // 탭 바에 뷰 컨트롤러 추가
        let viewControllers = [myPageVC, questVC, raceVC, boardVC]
        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
        
        // 탭 바 스타일 설정
        tabBar.tintColor = UIColor.orange // 선택된 아이템 색상
        tabBar.unselectedItemTintColor = UIColor.black // 선택되지 않은 아이템 색상
        tabBar.backgroundColor = UIColor.white // 배경색
    }
}



