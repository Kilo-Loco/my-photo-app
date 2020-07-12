// swiftlint:disable all
import Amplify
import Foundation

public struct Photo: Model, Identifiable {
  public let id: String
  public var key: String
  public var photographer: Photographer?
  
  public init(id: String = UUID().uuidString,
      key: String,
      photographer: Photographer? = nil) {
      self.id = id
      self.key = key
      self.photographer = photographer
  }
}
