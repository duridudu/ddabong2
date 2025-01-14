//
//  UIImage+Extension.swift
//  Ddabong2
//
//  Created by 안지희 on 1/14/25.
//


import UIKit

extension UIImage {
    static func profileImage(for avartaId: Int) -> UIImage? {
        let imageName = "avatar\(avartaId)"
        let image = UIImage(named: imageName)
        print("이미지 이름: \(imageName), 결과: \(image != nil ? "성공" : "실패")")
        return image
    }
}
