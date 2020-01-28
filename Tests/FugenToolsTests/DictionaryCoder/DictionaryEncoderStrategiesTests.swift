import XCTest
import FugenTools

final class DictionaryEncoderStrategiesTests: XCTestCase {

    // MARK: - Instance Methods

    private func makeExpectedDictionary<T: Encodable>(
        for value: T,
        keyEncodingStrategy: DictionaryKeyEncodingStrategy = .useDefaultKeys,
        dateEncodingStrategy: DictionaryDateEncodingStrategy = .deferredToDate,
        dataEncodingStrategy: DictionaryDataEncodingStrategy = .deferredToData,
        nonConformingFloatEncodingStrategy: DictionaryNonConformingFloatEncodingStrategy = .throw
    ) throws -> [String: Any] {
        let encoder = JSONEncoder()

        encoder.keyEncodingStrategy = keyEncodingStrategy.jsonEncodingStrategy
        encoder.dateEncodingStrategy = dateEncodingStrategy.jsonEncodingStrategy
        encoder.dataEncodingStrategy = dataEncodingStrategy.jsonEncodingStrategy
        encoder.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy.jsonEncodingStrategy

        let data = try encoder.encode(value)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

        return json as? [String: Any] ?? [:]
    }

    // MARK: -

    func testThatEncoderSucceedsWhenEncodingStructUsingDefaultKeys() {
        struct EncodableStruct: Encodable {
            let foo = 123
            let bar = 456
        }

        let keyEncodingStrategy = DictionaryKeyEncodingStrategy.useDefaultKeys
        let encoder = DictionaryEncoder(keyEncodingStrategy: keyEncodingStrategy)
        let value = EncodableStruct()

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: value,
                keyEncodingStrategy: keyEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(value)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatEncoderSucceedsWhenEncodingStructUsingCustomFunctionForKeys() {
        struct EncodableStruct: Encodable {
            let foo = 123
            let bar = 456
        }

        let keyEncodingStrategy = DictionaryKeyEncodingStrategy.custom { codingPath in
            codingPath.last.map { AnyCodingKey("\($0.stringValue).value") } ?? AnyCodingKey("unknown")
        }

        let encoder = DictionaryEncoder(keyEncodingStrategy: keyEncodingStrategy)
        let value = EncodableStruct()

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: value,
                keyEncodingStrategy: keyEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(value)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    // MARK: -

    func testThatEncoderSucceedsWhenEncodingDate() {
        let dateEncodingStrategy = DictionaryDateEncodingStrategy.deferredToDate
        let encoder = DictionaryEncoder(dateEncodingStrategy: dateEncodingStrategy)
        let dictionary = ["foobar": Date(timeIntervalSinceReferenceDate: 123.456)]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dateEncodingStrategy: dateEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatEncoderSucceedsWhenEncodingDateToMillisecondsSince1970() {
        let dateEncodingStrategy = DictionaryDateEncodingStrategy.millisecondsSince1970
        let encoder = DictionaryEncoder(dateEncodingStrategy: dateEncodingStrategy)
        let dictionary = ["foobar": Date(timeIntervalSinceReferenceDate: 123.456)]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dateEncodingStrategy: dateEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatEncoderSucceedsWhenEncodingDateToSecondsSince1970() {
        let dateEncodingStrategy = DictionaryDateEncodingStrategy.secondsSince1970
        let encoder = DictionaryEncoder(dateEncodingStrategy: dateEncodingStrategy)
        let dictionary = ["foobar": Date(timeIntervalSinceReferenceDate: 123.456)]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dateEncodingStrategy: dateEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatEncoderSucceedsWhenEncodingDateToISO8601Format() {
        let dateEncodingStrategy = DictionaryDateEncodingStrategy.iso8601
        let encoder = DictionaryEncoder(dateEncodingStrategy: dateEncodingStrategy)
        let dictionary = ["foobar": Date(timeIntervalSinceReferenceDate: 123.456)]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dateEncodingStrategy: dateEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatEncoderSucceedsWhenEncodingDateUsingFormatter() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateEncodingStrategy = DictionaryDateEncodingStrategy.formatted(dateFormatter)
        let encoder = DictionaryEncoder(dateEncodingStrategy: dateEncodingStrategy)
        let dictionary = ["foobar": Date(timeIntervalSinceReferenceDate: 123.456)]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dateEncodingStrategy: dateEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatEncoderSucceedsWhenEncodingDateUsingCustomFunction() {
        let dateEncodingStrategy = DictionaryDateEncodingStrategy.custom { date, encoder in
            var container = encoder.singleValueContainer()

            try container.encode("\(date.timeIntervalSince1970)")
        }

        let encoder = DictionaryEncoder(dateEncodingStrategy: dateEncodingStrategy)
        let dictionary = ["foobar": Date(timeIntervalSinceReferenceDate: 123.456)]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dateEncodingStrategy: dateEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    // MARK: -

    func testThatEncoderSucceedsWhenEncodingData() {
        let dataEncodingStrategy = DictionaryDataEncodingStrategy.deferredToData
        let encoder = DictionaryEncoder(dataEncodingStrategy: dataEncodingStrategy)
        let dictionary = ["foobar": Data([1, 2, 3])]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dataEncodingStrategy: dataEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatEncoderSucceedsWhenEncodingDataToBase64() {
        let dataEncodingStrategy = DictionaryDataEncodingStrategy.base64
        let encoder = DictionaryEncoder(dataEncodingStrategy: dataEncodingStrategy)
        let dictionary = ["foobar": Data([1, 2, 3])]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dataEncodingStrategy: dataEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatEncoderSucceedsWhenEncodingDataUsingCustomFunction() {
        let dataEncodingStrategy = DictionaryDataEncodingStrategy.custom { data, encoder in
            var container = encoder.singleValueContainer()

            let string = data
                .map { "\($0)" }
                .joined(separator: ", ")

            try container.encode(string)
        }

        let encoder = DictionaryEncoder(dataEncodingStrategy: dataEncodingStrategy)
        let dictionary = ["foobar": Data([1, 2, 3])]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                dataEncodingStrategy: dataEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    // MARK: -

    func testThatEncoderFailsWhenEncodingPositiveInfinityFloat() {
        let nonConformingFloatEncodingStrategy = DictionaryNonConformingFloatEncodingStrategy.throw
        let encoder = DictionaryEncoder(nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy)
        let number = Float.infinity
        let dictionary = ["foobar": number]

        do {
            _ = try encoder.encode(dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let EncodingError.invalidValue(invalidValue as Float, _):
                XCTAssertEqual(invalidValue, number)

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatEncoderFailsWhenEncodingNegativeInfinityFloat() {
        let nonConformingFloatEncodingStrategy = DictionaryNonConformingFloatEncodingStrategy.throw
        let encoder = DictionaryEncoder(nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy)
        let number = -Float.infinity
        let dictionary = ["foobar": number]

        do {
            _ = try encoder.encode(dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let EncodingError.invalidValue(invalidValue as Float, _):
                XCTAssertEqual(invalidValue, number)

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatEncoderFailsWhenEncodingNanFloat() {
        let nonConformingFloatEncodingStrategy = DictionaryNonConformingFloatEncodingStrategy.throw
        let encoder = DictionaryEncoder(nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy)
        let number = Float.nan
        let dictionary = ["foobar": number]

        do {
            _ = try encoder.encode(dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let EncodingError.invalidValue(invalidValue as Float, _):
                XCTAssertTrue(invalidValue.isNaN)

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatEncoderSucceedsWhenEncodingNonConformingFloatToString() {
        let nonConformingFloatEncodingStrategy = DictionaryNonConformingFloatEncodingStrategy.convertToString(
            positiveInfinity: "+∞",
            negativeInfinity: "-∞",
            nan: "¬"
        )

        let encoder = DictionaryEncoder(nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy)
        let dictionary = ["foo": Float.infinity, "bar": -Float.infinity, "baz": Float.nan]

        do {
            let expectedDictionary = try makeExpectedDictionary(
                for: dictionary,
                nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy
            )

            let encodedDictionary = try encoder.encode(dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedDictionary),
                NSDictionary(dictionary: encodedDictionary)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
}

private extension DictionaryKeyEncodingStrategy {

    // MARK: - Instance Properties

    var jsonEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        switch self {
        case .useDefaultKeys:
            return .useDefaultKeys

        case let .custom(closure):
            return .custom(closure)
        }
    }
}

private extension DictionaryDateEncodingStrategy {

    // MARK: - Instance Properties

    var jsonEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        switch self {
        case .deferredToDate:
            return .deferredToDate

        case .millisecondsSince1970:
            return .millisecondsSince1970

        case .secondsSince1970:
            return .secondsSince1970

        case .iso8601:
            return .iso8601

        case let .formatted(dateFormatter):
            return .formatted(dateFormatter)

        case let .custom(closure):
            return .custom(closure)
        }
    }
}

private extension DictionaryDataEncodingStrategy {

    // MARK: - Instance Properties

    var jsonEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        switch self {
        case .deferredToData:
            return .deferredToData

        case .base64:
            return .base64

        case let .custom(closure):
            return .custom(closure)
        }
    }
}

private extension DictionaryNonConformingFloatEncodingStrategy {

    // MARK: - Instance Properties

    var jsonEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy {
        switch self {
        case let .convertToString(positiveInfinity, negativeInfinity, nan):
            return .convertToString(
                positiveInfinity: positiveInfinity,
                negativeInfinity: negativeInfinity,
                nan: nan
            )

        case .throw:
            return .throw
        }
    }
}
