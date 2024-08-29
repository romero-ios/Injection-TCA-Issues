import TabBarFeature
import SwiftUI
import ComposableArchitecture

@Reducer
public struct AppFeature {
    @ObservableState
    public struct State: Equatable {
        public var appDelegate: AppDelegateReducer.State
        public var tabBar: TabBarFeature.State
        
        public init(
            appDelegate: AppDelegateReducer.State = .init(),
            tabBar: TabBarFeature.State = .init()
        ) {
            self.appDelegate = appDelegate
            self.tabBar = tabBar
        }
    }

    public enum Action {
        case appDelegate(AppDelegateReducer.Action)
        case tabBar(TabBarFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.tabBar, action: \.tabBar) {
            TabBarFeature()
        }
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching(_, _)):
                return .none
                
            case .tabBar:
                return .none
            }
        }
    }
}

public struct AppFeatureView: View {
    let store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }

    public var body: some View {
        Group {
            TabBarFeatureView(
                store: store.scope(
                    state: \.tabBar,
                    action: \.tabBar
                )
            )
        }
    }
}

#Preview {
    AppFeatureView(
        store: .init(
            initialState: .init(),
            reducer: {
                AppFeature()
            }
        )
    )
}
