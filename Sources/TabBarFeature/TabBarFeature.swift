import FirstFeature
import SecondFeature
import ThirdFeature
import SwiftUI
import ComposableArchitecture

@Reducer
public struct TabBarFeature {
    @ObservableState
    public struct State: Equatable {
        public enum Tab: Equatable {
            case one
            case two
            case three
        }
        
        public var selectedTab: Tab
        public var firstTab: FirstFeature.State
        public var secondTab: SecondFeature.State
        public var thirdTab: ThirdFeature.State
        
        public init(
            selectedTab: Tab = .one,
            firstTab: FirstFeature.State = .init(),
            secondTab: SecondFeature.State = .init(),
            thirdTab: ThirdFeature.State = .init()
        ) {
            self.selectedTab = selectedTab
            self.firstTab = firstTab
            self.secondTab = secondTab
            self.thirdTab = thirdTab
        }
    }
    
    public enum Action: BindableAction, Equatable {
        case firstTab(FirstFeature.Action)
        case secondTab(SecondFeature.Action)
        case thirdTab(ThirdFeature.Action)
        case binding(BindingAction<TabBarFeature.State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.firstTab, action: \.firstTab) {
            FirstFeature()
        }
        Scope(state: \.secondTab, action: \.secondTab) {
            SecondFeature()
        }
        Scope(state: \.thirdTab, action: \.thirdTab) {
            ThirdFeature()
        }
        Reduce { state, action in
            switch action {
            case .firstTab:
                return .none
                
            case .secondTab:
                return .none
                
            case .thirdTab:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}

public struct TabBarFeatureView: View {
    @Bindable var store: StoreOf<TabBarFeature>
    
    public init(store: StoreOf<TabBarFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TabView(selection: $store.selectedTab) {
            FirstFeatureView(
                store: self.store.scope(
                    state: \.firstTab,
                    action: \.firstTab
                )
            )
            .tag(TabBarFeature.State.Tab.one)
            .tabItem {
                TabItem(
                    image: Image(systemName: "1.circle"),
                    title: "one"
                )
            }
            
            SecondFeatureView(
                store: self.store.scope(
                    state: \.secondTab,
                    action: \.secondTab
                )
            )
            .tag(TabBarFeature.State.Tab.two)
            .tabItem {
                TabItem(
                    image: Image(systemName: "2.circle"),
                    title: "two"
                )
            }
            
            ThirdFeatureView(
                store: self.store.scope(
                    state: \.thirdTab,
                    action: \.thirdTab
                )
            )
            .tag(TabBarFeature.State.Tab.three)
            .tabItem {
                TabItem(
                    image: Image(systemName: "3.circle"),
                    title: "three"
                )
            }
        }
    }
}

struct TabItem: View {
    private let image: Image
    private let title: LocalizedStringKey
    
    init(image: Image, title: LocalizedStringKey) {
        self.image = image
        self.title = title
    }
    
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
            Text(title)
        }
    }
}

#Preview {
    TabBarFeatureView(
        store: .init(
            initialState: .init(),
            reducer: {
                TabBarFeature()
            }
        )
    )
}
