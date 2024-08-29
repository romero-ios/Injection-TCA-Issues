import Inject
import SwiftUI
import ComposableArchitecture

@Reducer
public struct SecondFeature {
    @ObservableState
    public struct State: Equatable {
        public var path: StackState<Path.State>
        
        public init(
            path: StackState<Path.State> = .init()
        ) {
            self.path = path
        }
    }
    
    public enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    @Reducer(state: .equatable, action: .equatable)
    public enum Path {
        case placeholder(SecondFeature)
    }
}

public struct SecondFeatureView: View {
    @ObserveInjection var inject
    @Bindable var store: StoreOf<SecondFeature>
    
    public init(store: StoreOf<SecondFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            NavigationStack(path: self.$store.scope(state: \.path, action: \.path)) {
                List {
                    ForEach(0..<20, id: \.self) { index in
                        Text("Index: \(index)")
                    }
                }
                .navigationTitle("Second Feature")
                .navigationBarTitleDisplayMode(.large)
                
            } destination: { pathStore in
                switch pathStore.case {
                case let .placeholder(store):
                    SecondFeatureView(store: store)
                }
            }
        }
        .enableInjection()
    }
}

#Preview {
    SecondFeatureView(
        store: .init(
            initialState: .init(),
            reducer: {
                SecondFeature()
            }
        )
    )
}

