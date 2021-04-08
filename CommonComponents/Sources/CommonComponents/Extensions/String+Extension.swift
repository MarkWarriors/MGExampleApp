//
//  File.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public extension String {

  static let empty = ""

  var isNumeric: Bool {
    return CharacterSet(charactersIn: self).isStrictSubset(of: CharacterSet.decimalDigits)
  }

  var doubleValue: Double? {
    return Double(self)
  }

  var floatValue: Float? {
    return Float(self)
  }

  var cgFloatValue: CGFloat? {
    if let value = self.floatValue {
      return CGFloat(value)
    }
    return nil
  }

  var intValue: Int? {
    return Int(self)
  }

  func removingUnicodeAndHtml() -> String {
    let mutableString = NSMutableString(string: self)
    CFStringTransform(mutableString, nil, "Any-Hex/Java" as NSString, true)
    let string = mutableString as String
    guard let data = string.data(using: .utf8) else { return string }
    guard let normalizedText = try? NSAttributedString(data: data,
                                                       options: [.documentType: NSAttributedString.DocumentType.html,
                                                                 .characterEncoding: String.Encoding.utf8.rawValue],
                                                       documentAttributes: nil).string else { return string }
    return normalizedText
  }

  func convertTextBetweenGivenStringToAnotherFont(newFont: UIFont, normalFont: UIFont, targetString: String) -> NSMutableAttributedString {
    let components = self.components(separatedBy: targetString)
    let attributedString = NSMutableAttributedString()
    for (index, text) in components.enumerated() {
      let isBold = (index % 2) != 0
      let attributedText = NSMutableAttributedString(string: text, attributes: [.font: isBold ? newFont : normalFont])
      attributedString.append(attributedText)
    }
    return attributedString
  }

  func attributedStringWith(_ strings: [String], color: UIColor? = nil, newFont: UIFont? = nil, characterSpacing: UInt? = nil) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: self)
    for string in strings {
      let range = (self as NSString).range(of: string)
      if let textColor = color {
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
      }
      if let font = newFont {
        attributedString.addAttribute(.font, value: font, range: range)
      }
    }
    guard let characterSpacing = characterSpacing else {return attributedString}
    attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
    return attributedString
  }

  struct Link {
    public let url: URL
    public let title: String

    public init(url: URL, title: String) {
      self.url = url
      self.title = title
    }
  }

  func attributedStringWithLinks(links: [Link], textColor: UIColor, linkColor: UIColor, linkFont: UIFont, textFont: UIFont) -> (textAttributes: NSAttributedString, linkattributes: [NSAttributedString.Key: Any]) {
    let attributedString = NSMutableAttributedString(string: self)
    attributedString.addAttribute(.font, value: textFont, range: NSRange(location: 0, length: attributedString.length))
    attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attributedString.length))

    for index in 0..<links.count {
      let range = (self as NSString).range(of: links[index].title)
      attributedString.addAttribute(.link, value: links[index].url, range: range)
      attributedString.addAttribute(.font, value: linkFont, range: range)
    }

    let linkAttributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.foregroundColor: linkColor,
      NSAttributedString.Key.underlineColor: UIColor.clear,
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    return (attributedString, linkAttributes)
  }
}

extension String: Error { }
