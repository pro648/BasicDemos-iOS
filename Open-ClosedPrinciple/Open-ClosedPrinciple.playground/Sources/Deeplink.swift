import Foundation

/*
enum DeeplinkType {
    case home
    case profile
    case settings
}

protocol Deeplink {
    var type: DeeplinkType { get }
}

class HomeDeeplink: Deeplink {
    let type: DeeplinkType = .home
    
    func executeHome() {
        // Presents the main screen
    }
}

class ProfileDeeplink: Deeplink {
    let type: DeeplinkType = .profile
    
    func executeProfile() {
        // Presents the profile screen
    }
}

class SettingsDeeplink: Deeplink {
    let type: DeeplinkType = .settings

    func executeSettings() {
        // Presents the Settings Screen
    }
}

class Router {
    func execute(_ deeplink: Deeplink) {
        switch deeplink.type {
        case .home:
            (deeplink as? HomeDeeplink)?.executeHome()
        case .profile:
            (deeplink as? ProfileDeeplink)?.executeProfile()
        case .settings:
            (deeplink as? SettingsDeeplink)?.executeSettings()
        }
    }
}
 */

// MARK: - OCP

protocol Deeplink {
    func execute()
}

class HomeDeeplink: Deeplink {
    func execute() {
        // Presents the main screen
    }
}

class ProfileDeeplink: Deeplink {
    func execute() {
        // Presents the Profile screen
    }
}

class Router {
    func execute(_ deeplink: Deeplink) {
        deeplink.execute()
    }
}

class SettingsDeeplink: Deeplink {
    func execute() {
        // Present the Settings Screen
    }
}
