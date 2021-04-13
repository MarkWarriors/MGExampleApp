//
//  CodableHelpers.swift
//
//
//  Created by Marco Guerrieri on 09/04/2021.
//

import Foundation

public protocol DefaultValueProvider {
  static var `default`: Self { get }
}

@propertyWrapper
public struct Default<Value: Codable & DefaultValueProvider>: Codable {
  public let wrappedValue: Value

  public var projectedValue: Default<Value> {
    get { self }
    set { self = newValue }
  }

  public init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.wrappedValue = {
      if container.decodeNil() {
        return .default
      } else {
        return (try? container.decode(Value.self)) ?? .default
      }
    }()
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue)
  }
}

extension Default: Equatable where Value: Equatable {}

extension Default: Hashable where Value: Hashable {}

public extension KeyedDecodingContainer {

  func decode<Value>(_: Default<Value>.Type, forKey key: Key) throws -> Default<Value> {
    if let value = try decodeIfPresent(Default<Value>.self, forKey: key) {
      return value
    } else {
      return Default(wrappedValue: Value.default)
    }
  }

}

@propertyWrapper public struct StringConvertible<Value: Codable & LosslessStringConvertible>: Codable {

  public let wrappedValue: Value

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let stringValue = try container.decode(String.self)
    if let value = Value(stringValue) {
      self.wrappedValue = value
    } else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to create a value of type '\(Value.self)' from a string value of '\(stringValue)'")
    }
  }

  public init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode("\(wrappedValue)")
  }
}

extension Double: DefaultValueProvider {
  public static var `default`: Double { 0 }
}

extension StringConvertible: DefaultValueProvider where Value: DefaultValueProvider {
  public static var `default`: StringConvertible<Value> { .init(wrappedValue: Value.default) }
}

public protocol CodableDefaultSource {
  associatedtype Value: Codable
  static var defaultValue: Value { get }
}

public enum CodableDefault {}
extension CodableDefault {
  @propertyWrapper
  public struct Wrapper<Source: CodableDefaultSource> {
    public typealias Value = Source.Value
    public var wrappedValue = Source.defaultValue
    public init() {}
  }
}
extension CodableDefault.Wrapper: Equatable where Value: Equatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.wrappedValue == rhs.wrappedValue
  }
}
extension CodableDefault.Wrapper: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    wrappedValue = try container.decode(Value.self)
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue)
  }
}


extension KeyedDecodingContainer {
  func decode<T>(_ type: CodableDefault.Wrapper<T>.Type, forKey key: Key) throws -> CodableDefault.Wrapper<T> {
    try decodeIfPresent(type, forKey: key) ?? .init()
  }
  func decode<T>(_ type: MappedCodable<T>.Type, forKey key: Key) throws -> MappedCodable<T> where T.Mapped: ExpressibleByNilLiteral {
    try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: nil)
  }
  func decode<T>(_ type: LossyArray<T>.Type, forKey key: Key) throws -> LossyArray<T> {
    try decodeIfPresent(type, forKey: key) ?? []
  }
  func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T where T: ExpressibleByNilLiteral {
    try decodeIfPresent(type, forKey: key) ?? nil
  }
}

public protocol CanBeEmpty {
  static var empty: Self { get }
}
extension String: CanBeEmpty {
  public static var empty: String { "" }
}
extension ExpressibleByDictionaryLiteral {
  public static var empty: Self { [:] }
}
extension ExpressibleByArrayLiteral {
  public static var empty: Self { [] }
}
extension Array: CanBeEmpty {}
extension Dictionary: CanBeEmpty {}

extension CodableDefault {
  public typealias List = Codable & ExpressibleByArrayLiteral & CanBeEmpty
  public typealias Map = Codable & ExpressibleByDictionaryLiteral & CanBeEmpty
  public typealias Number = Codable & Numeric

  public enum Sources {
    public enum Zero<T: Number>: CodableDefaultSource {
      public static var defaultValue: T { .zero }
    }
    public enum One<T: Number>: CodableDefaultSource {
      public static var defaultValue: T { 1 }
    }

    public enum True: CodableDefaultSource {
      public static var defaultValue: Bool { true }
    }

    public enum False: CodableDefaultSource {
      public static var defaultValue: Bool { false }
    }

    public enum Empty<T: Codable & CanBeEmpty>: CodableDefaultSource {
      public static var defaultValue: T { T.empty }
    }
  }
}

//public typealias DefaultNil<T: Codable> = CodableDefault.NilWrapper<T>
public typealias DefaultZero<T: CodableDefault.Number> = CodableDefault.Wrapper<CodableDefault.Sources.Zero<T>>
public typealias DefaultOne<T: CodableDefault.Number> = CodableDefault.Wrapper<CodableDefault.Sources.One<T>>
public typealias DefaultTrue = CodableDefault.Wrapper<CodableDefault.Sources.True>
public typealias DefaultFalse = CodableDefault.Wrapper<CodableDefault.Sources.False>
public typealias DefaultEmpty<T: Codable & CanBeEmpty> = CodableDefault.Wrapper<CodableDefault.Sources.Empty<T>>

// MARK: - Lossy array

@propertyWrapper
public struct LossyArray<T: Codable>: Codable, ExpressibleByArrayLiteral, CanBeEmpty {

  public typealias ArrayLiteralElement = T
  public init(arrayLiteral elements: Self.ArrayLiteralElement...) {
    wrappedValue = elements
  }

  // we previously saw the AnyDecodableValue technique
  private struct AnyCodableValue: Codable {}

  // LossyDecodableValue is a single value of a generic type that we attempt to decode
  private struct LossyDecodableValue<Value: Codable>: Codable {
    let value: Value

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      value = try container.decode(Value.self)
    }
  }

  // every property wrapper requires a wrappedValue
  public var wrappedValue: [T]

  public init(wrappedValue: [T]) {
    self.wrappedValue = wrappedValue
  }

  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()

    var elements: [T] = []

    // continue decoding until we get to the last element
    while !container.isAtEnd {
      do {
        // try to decode an arbitrary value of our generic type T
        let value = try container.decode(LossyDecodableValue<T>.self).value
        elements.append(value)
      } catch {
        // if that fails, no sweat—we still need to move our decoding cursor past that element
        _ = try? container.decode(AnyCodableValue.self)
      }
    }

    // and finally we store our elements
    self.wrappedValue = elements
  }
}

public protocol DecodableMapper {
  associatedtype Unmapped: Decodable
  associatedtype Mapped
  static func mapAfterDecoding(_ source: Unmapped) throws -> Mapped
}
public protocol EncodableMapper {
  associatedtype Unmapped: Encodable
  associatedtype Mapped
  static func mapBeforeEncoding(_ source: Mapped) throws -> Unmapped
}
public typealias CodableMapper = DecodableMapper & EncodableMapper

@propertyWrapper
public struct MappedDecodable<Mapper: DecodableMapper>: Decodable {
  public var wrappedValue: Mapper.Mapped
  public init(wrappedValue: Mapper.Mapped) {
    self.wrappedValue = wrappedValue
  }
}
extension MappedDecodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let source = try container.decode(Mapper.Unmapped.self)
    wrappedValue = try Mapper.mapAfterDecoding(source)
  }
}
@propertyWrapper
public struct MappedEncodable<Mapper: EncodableMapper>: Encodable {
  public var wrappedValue: Mapper.Mapped
  public init(wrappedValue: Mapper.Mapped) {
    self.wrappedValue = wrappedValue
  }
}
extension MappedEncodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    let source = try Mapper.mapBeforeEncoding(wrappedValue)
    try container.encode(source)
  }
}
@propertyWrapper
public struct MappedCodable<Mapper: CodableMapper>: Codable {
  public var wrappedValue: Mapper.Mapped
  public init(wrappedValue: Mapper.Mapped) {
    self.wrappedValue = wrappedValue
  }
}
extension MappedCodable: Equatable where Mapper.Mapped: Equatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.wrappedValue == rhs.wrappedValue
  }
}
extension MappedCodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let source = try container.decode(Mapper.Unmapped.self)
    wrappedValue = try Mapper.mapAfterDecoding(source)
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    let source = try Mapper.mapBeforeEncoding(wrappedValue)
    try container.encode(source)
  }
}
extension MappedCodable: CanBeEmpty where Mapper.Mapped: CanBeEmpty {
  public static var empty: Self { .init(wrappedValue: Mapper.Mapped.empty) }
}
extension MappedDecodable: CanBeEmpty where Mapper.Mapped: CanBeEmpty {
  public static var empty: Self { .init(wrappedValue: Mapper.Mapped.empty) }
}

public struct LowercasedMapper: CodableMapper {
  public static func mapAfterDecoding(_ source: String) throws -> String {
    source.lowercased()
  }
  public static func mapBeforeEncoding(_ source: String) throws -> String {
    source
  }
}
public typealias Lowercased = MappedCodable<LowercasedMapper>

public struct TrimmedMapper: CodableMapper {
  public static func mapAfterDecoding(_ source: String) throws -> String {
    source.trimmingCharacters(in: .whitespaces)
  }
  public static func mapBeforeEncoding(_ source: String) throws -> String {
    source
  }
}
public typealias Trimmed = MappedCodable<TrimmedMapper>

public struct DateFromStringMapper: CodableMapper {
  public static func mapAfterDecoding(_ source: String) throws -> Date {
    DateFormatter().date(from: source) ?? Date()
  }
  public static func mapBeforeEncoding(_ source: Date) throws -> String {
    DateFormatter().string(from: source)
  }
}
public typealias DateFromString = MappedCodable<DateFromStringMapper>
