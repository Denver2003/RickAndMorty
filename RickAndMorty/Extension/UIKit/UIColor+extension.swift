//
//  UIColor+extension.swift
//  RickAndMorty
//
//  Created by Denis Khlopin on 06.05.2021.
//

import UIKit

extension UIColor {
    static var background: UIColor {
        UIColor(named: "background") ?? .white
    }
    static var foreground: UIColor {
        UIColor(named: "foreground") ?? .white
    }
    static var active: UIColor {
        UIColor(named: "active") ?? .white
    }
    static var dead: UIColor {
        UIColor(named: "dead") ?? .white
    }
    static var unknown: UIColor {
        UIColor(named: "unknown") ?? .white
    }
    static var title: UIColor {
        UIColor(named: "title") ?? .white
    }
    static var subTitle: UIColor {
        UIColor(named: "subTitle") ?? .white
    }
}
