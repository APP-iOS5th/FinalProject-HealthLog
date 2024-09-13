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
        switch style {
            case .pretendardBlack:
                return HealthLogFontFamily.Pretendard.black.font(size: size)
            case .pretendardBold:
                return HealthLogFontFamily.Pretendard.bold.font(size: size)
            case .pretendardExtraBold:
                return HealthLogFontFamily.Pretendard.extraBold.font(size: size)
            case .pretendardExtraLight:
                return HealthLogFontFamily.Pretendard.extraLight.font(size: size)
            case .pretendardLight:
                return HealthLogFontFamily.Pretendard.light.font(size: size)
            case .pretendardMedium:
                return HealthLogFontFamily.Pretendard.medium.font(size: size)
            case .pretendardRegular:
                return HealthLogFontFamily.Pretendard.regular.font(size: size)
            case .pretendardSemiBold:
                return HealthLogFontFamily.Pretendard.semiBold.font(size: size)
            case .pretendardThin:
                return HealthLogFontFamily.Pretendard.thin.font(size: size)
        }
    }
}
