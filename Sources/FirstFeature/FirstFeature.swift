import LeafFeature
import SwiftUI
import ComposableArchitecture
import Inject

@Reducer
public struct FirstFeature {
    @ObservableState
    public struct State: Equatable {
        public var leafCount: Int
        public var path: StackState<Path.State>
        
        public init(
            leafCount: Int = 0,
            path: StackState<Path.State> = .init()
        ) {
            self.leafCount = leafCount
            self.path = path
        }
    }
    
    public enum Action: Equatable {
        case buttonTapped
        case path(StackAction<Path.State, Path.Action>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .buttonTapped:
                state.leafCount += 1
                state.path.append(.leaf(.init(id: state.leafCount)))
                return .none
                
            case .path(.element(id: _, action: .leaf(.delegate(.nextScreen)))):
                state.leafCount += 1
                state.path.append(.leaf(.init(id: state.leafCount)))
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    @Reducer(state: .equatable, action: .equatable)
    public enum Path {
        case leaf(LeafFeature)
    }
}

public struct FirstFeatureView: View {
    @Bindable var store: StoreOf<FirstFeature>
    
    public init(store: StoreOf<FirstFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: self.$store.scope(state: \.path, action: \.path)) {
            RootContainer(onButtonTap: { store.send(.buttonTapped) })
        } destination: { pathStore in
            switch pathStore.case {
            case let .leaf(store):
                LeafFeatureView(store: store)
            }
        }
    }
}

struct RootContainer: View {
    @ObserveInjection var inject
    
    var onButtonTap: () -> Void
    
    var body: some View {
        VStack {
            Text("Test")
            Button(action: onButtonTap) {
                Text("Push leaf >")
            }
        }
        .navigationTitle("First Feature")
        .navigationBarTitleDisplayMode(.large)
        .enableInjection()
    }
}

#Preview {
    FirstFeatureView(
        store: .init(
            initialState: .init(),
            reducer: {
                FirstFeature()
            }
        )
    )
}
