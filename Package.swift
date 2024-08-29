// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "injectiondemo",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: Module.allProducts,
    dependencies: ExternalModule.allPackageDependencies,
    targets: Module.allTargets
)

enum Module: String, CaseIterable {
    // Features
    case appFeature = "AppFeature"
    case tabBarFeature = "TabBarFeature"
    case firstFeature = "FirstFeature"
    case secondFeature = "SecondFeature"
    case thirdFeature = "ThirdFeature"
    case leafFeature = "LeafFeature"
    
    static let allProducts: [Product] = {
        Self.allCases.map { $0.product }
    }()
    
    static let allTargets: [Target] = {
        Self.allCases.map { $0.target }
    }()
    
    var product: Product {
        return .library(module: self)
    }
    
    var targetDependency: Target.Dependency {
        return .target(module: self)
    }
    
    var targetDependencies: [Target.Dependency] {
        switch self {
        case .appFeature:
            [
                Module.tabBarFeature.targetDependency,
                ExternalModule.composableArchitecture.targetDependency,
            ]
        case .tabBarFeature:
            [
                Module.firstFeature.targetDependency,
                Module.secondFeature.targetDependency,
                Module.thirdFeature.targetDependency,
                ExternalModule.composableArchitecture.targetDependency,
            ]
        case.firstFeature:
            [
                Module.leafFeature.targetDependency,
                ExternalModule.injection.targetDependency,
                ExternalModule.composableArchitecture.targetDependency,
            ]
        case .secondFeature:
            [
                Module.leafFeature.targetDependency,
                ExternalModule.injection.targetDependency,
                ExternalModule.composableArchitecture.targetDependency,
            ]
        case .thirdFeature:
            [
                Module.leafFeature.targetDependency,
                ExternalModule.injection.targetDependency,
                ExternalModule.composableArchitecture.targetDependency,
            ]
        case .leafFeature:
            [
                ExternalModule.injection.targetDependency,
                ExternalModule.composableArchitecture.targetDependency,
            ]
        }
    }
    
    var target: Target {
        switch self {
        default:
            return .target(
                module: self,
                dependencies: targetDependencies
            )
        }
    }
}

enum ExternalModule: CaseIterable {
    case injection
    case composableArchitecture
    
    static let allPackageDependencies: [Package.Dependency] = {
         return Self.allCases
             .map { $0.packageDependency }
     }()
    
    var packageDependency: Package.Dependency {
        switch self {
        case .injection:
            return .package(url: "https://github.com/krzysztofzablocki/Inject", exact: "1.5.2")
            
        case .composableArchitecture:
            return .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.8.2")
        }
    }
    
    var targetDependency: Target.Dependency {
        switch self {
        case .injection:
            return .product(name: "Inject", package: "Inject")
            
        case .composableArchitecture:
            return .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        }
    }
}


extension Product {
    static func library(module: Module) -> Product {
        return .library(name: module.rawValue, targets: [module.rawValue])
    }
}

extension Target.Dependency {
    static func target(module: Module) -> Target.Dependency {
        return .target(name: module.rawValue)
    }
}

extension Target {
    static func target(
        module: Module,
        dependencies: [Target.Dependency],
        resources: [Resource]? = nil
    ) -> Target {
        return .target(
            name: module.rawValue,
            dependencies: dependencies,
            resources: resources
        )
    }
}
