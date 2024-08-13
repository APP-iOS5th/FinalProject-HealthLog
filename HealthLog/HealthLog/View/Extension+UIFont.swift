//
//  Extension+UIFont.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit
enum FontName: String {
    case pretendardBlack = "Pretendard-Black"
    case pretendardBold = "Pretendard-Bold"
    case pretendardExtraBold = "Pretendard-ExtraBold"
    case pretendardExtraLight = "Pretendard-ExtraLight"
    case pretendardLight = "Pretendard-Light"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardThin = "Pretendard-Thin"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
           guard let customFont = UIFont(name: style.rawValue, size: size) else {
               return UIFont.systemFont(ofSize: size)
           }
           return customFont
       }
}
