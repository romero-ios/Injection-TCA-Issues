import SwiftUI
import ComposableArchitecture
import Inject

@Reducer
public struct ThirdFeature {
    @ObservableState
    public struct State: Equatable {
        public var path: StackState<Path.State>
        public var count: Int
        
        public init(
            path: StackState<Path.State> = .init(),
            count: Int = 0
        ) {
            self.path = path
            self.count = count
        }
    }
    
    public enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case incrementTapped
        case decrementTapped
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none

            case .incrementTapped:
                state.count += 1
                return .none
                
            case .decrementTapped:
                state.count -= 1
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    @Reducer(state: .equatable, action: .equatable)
    public enum Path {
        case placeholder(ThirdFeature)
    }
}

public struct ThirdFeatureView: View {
    @ObserveInjection var inject
    @Bindable var store: StoreOf<ThirdFeature>
    
    public init(store: StoreOf<ThirdFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            NavigationStack(path: self.$store.scope(state: \.path, action: \.path)) {
                VStack {
                    Text("Counter: \(store.count)")
                    HStack {
                        Button("-") {
                            store.send(.decrementTapped)
                        }
                        .padding()
                        Button("+") {
                            store.send(.incrementTapped)
                        }
                        .padding()
                    }
                }
                .navigationTitle("Third Feature")
                .navigationBarTitleDisplayMode(.large)
                
            } destination: { pathStore in
                switch pathStore.case {
                case let .placeholder(store):
                    ThirdFeatureView(store: store)
                }
            }
        }
        .enableInjection()
    }
}

#Preview {
    ThirdFeatureView(
        store: .init(
            initialState: .init(),
            reducer: {
                ThirdFeature()
            }
        )
    )
}
