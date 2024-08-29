import SwiftUI
import ComposableArchitecture
import Inject

@Reducer
public struct LeafFeature {
    @ObservableState
    public struct State: Equatable {
        public var id: Int
        
        public init(
            id: Int = 0
        ) {
            self.id = id
        }
    }
    
    public enum Action: Equatable {
        case buttonTapped
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case nextScreen
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .buttonTapped:
                return .send(.delegate(.nextScreen))
                
            case .delegate:
                return .none
            }
        }
    }
}

public struct LeafFeatureView: View {
    @ObserveInjection var inject
    let store: StoreOf<LeafFeature>
    
    public init(store: StoreOf<LeafFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("LeafFeatureView")
            Button(action: { store.send(.buttonTapped) }) {
                Text("Next screen")
            }
        }
        .navigationTitle("Leaf Feature \(store.id)")
        .navigationBarTitleDisplayMode(.large)
        .enableInjection()
    }
}

#Preview {
    LeafFeatureView(
        store: .init(
            initialState: .init(),
            reducer: {
                LeafFeature()
            }
        )
    )
}
