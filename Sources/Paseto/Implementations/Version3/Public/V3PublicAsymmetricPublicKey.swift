import Foundation
import CryptoKit

extension Version3.Public {
    public struct AsymmetricPublicKey  {
        public static let length = 49

        let key: P384.Signing.PublicKey

        var compressed: Bytes {
            [02] + key.compactRepresentation!.bytes
        }

        public var material: Bytes {
            compressed
        }

        public init (material: Bytes) throws {
            guard material.count == Module.AsymmetricPublicKey.length else {
                throw Exception.badLength(
                    "Public key must be 49 bytes long; \(material.count) given."
                )
            }

            guard let key = try? P384.Signing.PublicKey(x963Representation: material) else {
                throw Exception.badKey("Public key is invalid")
            }

            self.key = key
        }

        init (key: P384.Signing.PublicKey) {
            self.key = key
        }
    }
}

extension Version3.Public.AsymmetricPublicKey : Paseto.AsymmetricPublicKey {
    public typealias Module = Version3.Public
}

public extension Version3.Public.AsymmetricPublicKey  {
    enum Exception: Error {
        case badLength(String)
        case badKey(String)
    }
}
