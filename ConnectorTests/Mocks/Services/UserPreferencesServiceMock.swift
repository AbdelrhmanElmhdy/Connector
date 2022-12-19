// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery

import UIKit
@testable import Connector

class UserPreferencesServiceMock: UserPreferencesService {


    var userDefaultsManager: UserDefaultsManager {
        get { return underlyingUserDefaultsManager }
        set(value) { underlyingUserDefaultsManager = value }
    }
    var underlyingUserDefaultsManager: UserDefaultsManager!

    //MARK: - updateUserInterfaceStyle

    var updateUserInterfaceStyleWithCallsCount = 0
    var updateUserInterfaceStyleWithCalled: Bool {
        return updateUserInterfaceStyleWithCallsCount > 0
    }
    var updateUserInterfaceStyleWithReceivedState: UIUserInterfaceStyle?
    var updateUserInterfaceStyleWithReceivedInvocations: [UIUserInterfaceStyle] = []
    var updateUserInterfaceStyleWithClosure: ((UIUserInterfaceStyle) -> Void)?

    func updateUserInterfaceStyle(with state: UIUserInterfaceStyle) {
        updateUserInterfaceStyleWithCallsCount += 1
        updateUserInterfaceStyleWithReceivedState = state
        updateUserInterfaceStyleWithReceivedInvocations.append(state)
        updateUserInterfaceStyleWithClosure?(state)
    }

    //MARK: - saveChanges

    var saveChangesCallsCount = 0
    var saveChangesCalled: Bool {
        return saveChangesCallsCount > 0
    }
    var saveChangesClosure: (() -> Void)?

    func saveChanges() {
        saveChangesCallsCount += 1
        saveChangesClosure?()
    }

}
