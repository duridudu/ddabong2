//
//  File.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/11/25.
//

import Foundation
import UIKit
import SideMenu

class TestViewController:UIViewController{
    private var sideMenu: SideMenuNavigationController?
    
    private var currentChildViewController: UIViewController? // 현재 표시 중인 뷰 컨트롤러
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var lblRight: UILabel!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func btnMenu(_ sender: UIButton) {
        guard let sideMenu = sideMenu else { return }
        present(sideMenu, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchToViewController(identifier: "CV1")
        
    }
    
    private func setupSideMenu() {
        let menuViewController = MenuViewController()
        sideMenu = SideMenuNavigationController(rootViewController: menuViewController)
        sideMenu?.leftSide = true
        sideMenu?.menuWidth = 300
        sideMenu?.presentationStyle = .menuSlideIn
    }
    
    @IBAction func btn1Clicked(_ sender: Any) {
        btn1.titleLabel?.textColor = .red
        btn2.titleLabel?.textColor = .black
        lblLeft.isHidden = true
        lblRight.isHidden = false
        switchToViewController(identifier: "CV1")
    }
    
    @IBAction func btn2Clicked(_ sender: Any) {
        btn1.titleLabel?.textColor = .black
        btn2.titleLabel?.textColor = .red
       
        
        lblLeft.isHidden = false
        lblRight.isHidden = true
        switchToViewController(identifier: "CV2")
    }
    
    // 뷰 컨트롤러 교체 함수
    private func switchToViewController(identifier: String) {
        // 현재 표시 중인 뷰 컨트롤러 제거
        if let current = currentChildViewController {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
            // 추가로 컨테이너 뷰에서 모든 서브뷰 제거
            containerView.subviews.forEach { $0.removeFromSuperview() }
        }
        
        // 새 뷰 컨트롤러 가져오기
        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: identifier) else {
            print("ViewController with identifier \(identifier) not found.")
            return
        }
        
        // 새 뷰 컨트롤러 추가
        addChild(newViewController)
        newViewController.view.frame = containerView.bounds
        containerView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
        
        // 현재 표시 중인 뷰 컨트롤러 업데이트
        currentChildViewController = newViewController
    }
    
}
