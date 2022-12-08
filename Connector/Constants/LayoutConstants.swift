import UIKit

struct LayoutConstants {
    static let isScreenTall = screenHeight / screenWidth > 16 / 9
	static let screenHeight = UIScreen.main.bounds.size.height
	static let screenWidth = UIScreen.main.bounds.size.width
}
