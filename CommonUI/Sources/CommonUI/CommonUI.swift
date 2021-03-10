import UIKit

public func initializeFonts() {
  UIFont.registerFont(bundle: .module, fontName: "Cyberpunk-Regular", fontExtension: "ttf")
  UIFont.registerFont(bundle: .module, fontName: "Git-Sans", fontExtension: "ttf")
  UIFont.registerFont(bundle: .module, fontName: "Timeburner", fontExtension: "ttf")
  UIFont.registerFont(bundle: .module, fontName: "TimeburnerBold", fontExtension: "ttf")
}

public struct Images {
  public static let logo = UIImage.named("Logo")
  public static let logoInline = UIImage.named("LogoInline")
}

public struct Colors {
  public static let primaryText = UIColor.named("primaryText")
  public static let secondaryText = UIColor.named("secondaryText")
  public static let specialText = UIColor.named("specialText")
}

public struct Fonts {
  public struct Cyberpunk {
    public static let b1 = UIFont(name: "Cyberpunk-Regular", size: 20)
    public static let h1 = UIFont(name: "Cyberpunk-Regular", size: 36)
  }

  public struct GitSans {
    public static let b1 = UIFont(name: "Git-Sans", size: 20)
    public static let b2 = UIFont(name: "Git-Sans", size: 16)

    public static let h1 = UIFont(name: "Git-Sans", size: 36)
    public static let h2 = UIFont(name: "Git-Sans", size: 24)
  }

  public struct Timeburner {
    public static let b1 = UIFont(name: "TimeBurner", size: 20)
    public static let b2 = UIFont(name: "TimeBurner", size: 16)

    public static let h1 = UIFont(name: "TimeBurner Bold", size: 36)
    public static let h2 = UIFont(name: "TimeBurner Bold", size: 24)
  }
}
