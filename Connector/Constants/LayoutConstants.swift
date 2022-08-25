import UIKit

struct LayoutConstants {
	static let isScreenTall = screenHeight / screenWidth > 1.8
    static var safeAreaInsets: UIEdgeInsets {
        UIEdgeInsets(top: isScreenTall ? 134 : 30, left: 0, bottom: isScreenTall ? 34 : 0, right: 0)
    }
	static let screenHeight = UIScreen.main.bounds.size.height
	static let screenWidth = UIScreen.main.bounds.size.width
    static let inputHeight: CGFloat = 52
	static let calendarViewPopoverCellHeight: CGFloat = 45
	static let calendarViewPopoverWidth: CGFloat = 200
    static let sideMenuBtnHeight: CGFloat = 40
    static let tabBarHeight = screenHeight * 0.1
}
