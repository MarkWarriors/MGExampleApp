//
//  Helpers.swift
//  
//
//  Created by Marco Guerrieri on 17/12/2020.
//

import UIKit

internal extension UIFont {

  static var needToRegisterFonts = true
  
  @discardableResult
  static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
    guard needToRegisterFonts else { return true }

    guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
      fatalError("Couldn't find font \(fontName)")
    }

    guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
      fatalError("Couldn't load data from the font \(fontName)")
    }

    guard let font = CGFont(fontDataProvider) else {
      fatalError("Couldn't create font from data")
    }

    var error: Unmanaged<CFError>?
    let success = CTFontManagerRegisterGraphicsFont(font, &error)
    guard success else {
      print("Error registering font \(font.fullName ?? "unkown" as CFString): maybe it was already registered.")
      return false
    }

    needToRegisterFonts = false
    return true
  }
}

internal extension UIColor {
  static func named(_ name: String) -> UIColor {
    return UIColor(named: name, in: .module, compatibleWith: nil)!
  }
}

internal extension UIImage {
  static func named(_ name: String) -> UIImage {
    return UIImage(named: name, in: .module, with: nil)!
  }
}
