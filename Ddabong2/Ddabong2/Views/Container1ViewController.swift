//
//  Container1ViewController.swift
//  Ddabong2
//
//  Created by 이윤주 on 1/11/25.
//

import Foundation
import UIKit
class Container1ViewController:UIViewController{
    @IBOutlet weak var bg1: UILabel!
    @IBOutlet weak var bg2: UILabel!
    @IBOutlet weak var bg0: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = UIColor(hex: "fff8f8")
        // 테두리 및 corner radius 설정
        bg1.layer.borderWidth = 2.0 // 테두리 두께
        bg1.backgroundColor = .white
        bg1.layer.borderColor = UIColor(hex: "eaeaea").cgColor // 테두리 색상
        bg1.layer.cornerRadius = 40.0 // 테두리의 둥글기
        bg1.layer.masksToBounds = true // corner radius가 적용되도록 설정
        
        // 테두리 및 corner radius 설정
        bg2.layer.borderWidth = 2.0 // 테두리 두께
        bg2.backgroundColor = .white
        bg2.layer.borderColor = UIColor(hex: "eaeaea").cgColor // 테두리 색상
        bg2.layer.cornerRadius = 40.0 // 테두리의 둥글기
        bg2.layer.masksToBounds = true // corner radius가 적용되도록 설정
        
        // 테두리 및 corner radius 설정
        bg0.layer.borderWidth = 2.0 // 테두리 두께
        bg0.backgroundColor = .white
        bg0.layer.borderColor = UIColor(hex: "eaeaea").cgColor // 테두리 색상
        bg0.layer.cornerRadius = 40.0 // 테두리의 둥글기
        bg0.layer.masksToBounds = true // corner radius가 적용되도록 설정

        
        
    }
}
