import XCTest
@testable import Paseto
import CryptoKit
import Sodium

class KeyTest: XCTestCase {
#if compiler(>=5.7)
    @available(macOS 13, *)
    func testGeneratedKeyImport() {
        for _ in 1...100 {
            let privKey = P384.Signing.PrivateKey(compactRepresentable: false)

            let pubKey = privKey.publicKey

            let pasetoPubKey = Paseto.Version3.AsymmetricPublicKey(bytes: pubKey.compressedRepresentation)!

            XCTAssertEqual(pubKey.rawRepresentation.bytes, pasetoPubKey.key.rawRepresentation.bytes)
        }
    }

    @available(macOS 13, *)
    func testRandomKeyImport() {
        for _ in 1...100 {
            let bytes = [Util.random(length: 1)[0] % 2 == 0 ? 02 : 03] + Util.random(length: 48)

            let pasetoPubKey = Paseto.Version3.AsymmetricPublicKey(bytes: bytes)
            let pubKey = try? P384.Signing.PublicKey(compressedRepresentation: bytes)

            XCTAssertEqual(pubKey?.rawRepresentation.bytes, pasetoPubKey?.key.rawRepresentation.bytes)
        }
    }
#endif
}

