//
//  File.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/11/25.
//

import Foundation
import UIKit

class TestViewController:UIViewController{
    private var currentChildViewController: UIViewController? // 현재 표시 중인 뷰 컨트롤러
    @IBOutlet weak var containerView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchToViewController(identifier: "CV1")
        
    }
    
    @IBAction func btn1Clicked(_ sender: Any) {
        print("!!")
        switchToViewController(identifier: "CV1")
    }
    
    @IBAction func btn2Clicked(_ sender: Any) {
        print("@@")
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
