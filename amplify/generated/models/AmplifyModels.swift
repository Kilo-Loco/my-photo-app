// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "5cf3c99e0a9934e79e606d2dd564dffa"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Photo.self)
    ModelRegistry.register(modelType: Photographer.self)
  }
}