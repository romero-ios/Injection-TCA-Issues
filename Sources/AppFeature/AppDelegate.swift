import Inject
import Foundation
import UIKit
import ComposableArchitecture

public protocol UIApplicationProtocol {}

extension UIApplication: UIApplicationProtocol {}

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public let store = Store(
        initialState: AppFeature.State(),
        reducer: {
            AppFeature()
        }
    )
    
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Inject setup code
        #if DEBUG
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif
        InjectConfiguration.animation = .interactiveSpring()
        
        self.store.send(.appDelegate(.didFinishLaunching(application: application, launchOptions: launchOptions)))
        return true
    }
}

@Reducer
public struct AppDelegateReducer: Reducer {
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case didFinishLaunching(application: UIApplicationProtocol, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .didFinishLaunching:
                return .none
            }
        }
    }
}
