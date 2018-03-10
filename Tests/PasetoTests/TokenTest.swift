//
//  TokenTest.swift
//  PasetoTests
//
//  Created by Aidan Woods on 09/03/2018.
//

import XCTest
import Paseto

class TokenTest: XCTestCase {
    func testDecrypt() {
        // setup
        let message = """
            v2.local.lClhzVOuseCWYep44qbA8rmXry66lUupyENijX37_I_z34EiOlfyuwqII
            hOjF-e9m2J-Qs17Gs-BpjpLlh3zf-J37n7YGHqMBV6G5xD2aeIKpck6rhfwHpGF38L
            7ryYuzuUeqmPg8XozSfU4PuPp9o8.UGFyYWdvbiBJbml0aWF0aXZlIEVudGVycHJpc
            2Vz
            """.replacingOccurrences(of: "\n", with: "")

        // load a version2 symmetric key
        let key = try! SymmetricKey<Version2>(
            encoded: "cHFyc3R1dnd4eXp7fH1-f4CBgoOEhYaHiImKi4yNjo8"
        )

        // we expect our message is encrypted (i.e. a "local" purpose)
        let blob = Blob<Encrypted>(message)!
        // encrypted blobs are specialised to have a decrypt method
        // to obtain a token, given a symmetric key
        let token = blob.decrypt(with: key)!

        // test our token is what we expected
        let expectedClaims = [
            "data": "this is a signed message",
            "expires": "2019-01-01T00:00:00+00:00",
        ]
        XCTAssertEqual(expectedClaims, token.claims)

        let expectedFooter = "Paragon Initiative Enterprises"
        XCTAssertEqual(expectedFooter, token.footer)

        // allowed versions should be identical to that of the type of key used
        // for decryption
        XCTAssertEqual([type(of: key).version], token.allowedVersions)
    }

    func testEncrypt() {
        let token = Token(claims: ["foo": "bar"])
            .replace(allowedVersions: [.v2])
            .replace(footer: "There be secrets within...")
            .add(claims: [
                "bar": "baz",
                "boo": "bop",
            ])

        let key = SymmetricKey<Version2>()

        let blob = token.encrypt(with: key)!
        let unsealedToken = blob.decrypt(with: key)!

        let expectedClaims = [
            "foo": "bar",
            "bar": "baz",
            "boo": "bop",
        ]
        XCTAssertEqual(unsealedToken.claims, expectedClaims)

        let expectedFooter = "There be secrets within..."
        XCTAssertEqual(unsealedToken.footer, expectedFooter)

        let expectedVersions: [Version] = [.v2]
        XCTAssertEqual(unsealedToken.allowedVersions, expectedVersions)
    }
}