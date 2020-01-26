import XCTest
import FugenTools

final class DictionaryDecoderTests: XCTestCase {

    // MARK: - Instance Methods

    private func makeExpectedValue<T: Decodable>(
        _ type: T.Type,
        from dictionary: [String: Any],
        keyDecodingStrategy: DictionaryKeyDecodingStrategy = .useDefaultKeys,
        dateDecodingStrategy: DictionaryDateDecodingStrategy = .deferredToDate,
        dataDecodingStrategy: DictionaryDataDecodingStrategy = .deferredToData,
        nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy = .throw
    ) throws -> T {
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = dateDecodingStrategy.jsonDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy.jsonDecodingStrategy

        let data = try JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed)
        let value = try decoder.decode(T.self, from: data)

        return value
    }

    // MARK: -

    func testThatDecoderSucceedsWhenDecodingEmptyDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = [:]
        let valueType = [String: String].self

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToBoolDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foo": true, "bar": false]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToIntDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foo": 123, "bar": -456]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt8Dictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: Int8] = ["foo": 12, "bar": -34]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt16Dictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: Int16] = ["foo": 123, "bar": -456]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt32Dictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: Int32] = ["foo": 123, "bar": -456]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToInt64Dictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: Int64] = ["foo": 123, "bar": -456]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUIntDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: UInt] = ["foo": 123, "bar": 456]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt8Dictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: UInt8] = ["foo": 12, "bar": 45]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt16Dictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: UInt16] = ["foo": 123, "bar": 456]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt32Dictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: UInt32] = ["foo": 123, "bar": 456]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToUInt64Dictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: UInt64] = ["foo": 123, "bar": 456]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToDoubleDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foo": 1.23, "bar": -45.6]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToFloatDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: Float] = ["foo": 1.23, "bar": -45.6]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToStringDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foo": "qwe", "bar": "asd"]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingStringToArrayDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: [Int?]] = ["foo": [1, 2, 3], "bar": [4, nil, 6]]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingNestedStringToIntDictionary() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foo": ["bar": 123, "baz": -456]]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    func testThatDecoderSucceedsWhenDecodingNestedArrayOfStringToIntDictionaries() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foo": [["bar": 123, "baz": 456]]]
        let valueType = type(of: dictionary)

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedValue(valueType, from: dictionary)),
            NSDictionary(dictionary: try decoder.decode(valueType, from: dictionary))
        )
    }

    // MARK: -

    func testThatDecoderSucceedsWhenDecodingDate() {
        let dateDecodingStrategy = DictionaryDateDecodingStrategy.deferredToDate
        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": 123.456]
        let valueType = [String: Date].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dateDecodingStrategy: dateDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidDate() {
        let dateDecodingStrategy = DictionaryDateDecodingStrategy.deferredToDate
        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": "qwe"]
        let valueType = [String: Date].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Double.Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDateFromMillisecondsSince1970() {
        let dateDecodingStrategy = DictionaryDateDecodingStrategy.millisecondsSince1970
        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": 123_456.789]
        let valueType = [String: Date].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dateDecodingStrategy: dateDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderSucceedsWhenDecodingDateFromSecondsSince1970() {
        let dateDecodingStrategy = DictionaryDateDecodingStrategy.secondsSince1970
        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": 123.456]
        let valueType = [String: Date].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dateDecodingStrategy: dateDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderSucceedsWhenDecodingDateFromISO8601Format() {
        let dateDecodingStrategy = DictionaryDateDecodingStrategy.iso8601
        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": "2001-01-01T00:02:03Z"]
        let valueType = [String: Date].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dateDecodingStrategy: dateDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidDateFromISO8601Format() {
        let dateDecodingStrategy = DictionaryDateDecodingStrategy.iso8601
        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": "qwe"]
        let valueType = [String: Date].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case DecodingError.dataCorrupted:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDateUsingFormatter() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateDecodingStrategy = DictionaryDateDecodingStrategy.formatted(dateFormatter)
        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": "2001-01-01"]
        let valueType = [String: Date].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dateDecodingStrategy: dateDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidDateUsingFormatter() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateDecodingStrategy = DictionaryDateDecodingStrategy.formatted(dateFormatter)
        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": "qwe"]
        let valueType = [String: Date].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case DecodingError.dataCorrupted:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDateUsingCustomFunction() {
        let dateDecodingStrategy = DictionaryDateDecodingStrategy.custom { decoder in
            let container = try decoder.singleValueContainer()

            guard let timeIntervalSince1970 = TimeInterval(try container.decode(String.self)) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date")
            }

            return Date(timeIntervalSince1970: timeIntervalSince1970)
        }

        let decoder = DictionaryDecoder(dateDecodingStrategy: dateDecodingStrategy)
        let dictionary = ["foobar": "123.456"]
        let valueType = [String: Date].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dateDecodingStrategy: dateDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    // MARK: -

    func testThatDecoderSucceedsWhenDecodingData() {
        let dataDecodingStrategy = DictionaryDataDecodingStrategy.deferredToData
        let decoder = DictionaryDecoder(dataDecodingStrategy: dataDecodingStrategy)
        let dictionary: [String: [UInt8]] = ["foobar": [1, 2, 3]]
        let valueType = [String: Data].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dataDecodingStrategy: dataDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidData() {
        let dataDecodingStrategy = DictionaryDataDecodingStrategy.deferredToData
        let decoder = DictionaryDecoder(dataDecodingStrategy: dataDecodingStrategy)
        let dictionary = ["foobar": "qwe"]
        let valueType = [String: Data].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [Any].Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDataToBase64() {
        let dataDecodingStrategy = DictionaryDataDecodingStrategy.base64
        let decoder = DictionaryDecoder(dataDecodingStrategy: dataDecodingStrategy)
        let dictionary = ["foobar": "AQID"]
        let valueType = [String: Data].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dataDecodingStrategy: dataDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidDataToBase64() {
        let dataDecodingStrategy = DictionaryDataDecodingStrategy.base64
        let decoder = DictionaryDecoder(dataDecodingStrategy: dataDecodingStrategy)
        let dictionary = ["foobar": "123"]
        let valueType = [String: Data].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case DecodingError.dataCorrupted:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderSucceedsWhenDecodingDataUsingCustomFunction() {
        let dataDecodingStrategy = DictionaryDataDecodingStrategy.custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            let bytes = string
                .components(separatedBy: ", ")
                .compactMap { UInt8($0) }

            return Data(bytes)
        }

        let decoder = DictionaryDecoder(dataDecodingStrategy: dataDecodingStrategy)
        let dictionary = ["foobar": "1, 2, 3"]
        let valueType = [String: Data].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                dataDecodingStrategy: dataDecodingStrategy
            )

            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(
                NSDictionary(dictionary: expectedValue),
                NSDictionary(dictionary: decodedValue)
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidDataUsingCustomFunction() {
        let dataDecodingStrategy = DictionaryDataDecodingStrategy.custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            let bytes = string
                .components(separatedBy: ", ")
                .compactMap { UInt8($0) }

            return Data(bytes)
        }

        let decoder = DictionaryDecoder(dataDecodingStrategy: dataDecodingStrategy)
        let dictionary = ["foobar": 123]
        let valueType = [String: Data].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is String.Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }
}

private extension DictionaryDateDecodingStrategy {

    // MARK: - Instance Properties

    var jsonDecodingStrategy: JSONDecoder.DateDecodingStrategy {
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

private extension DictionaryDataDecodingStrategy {

    // MARK: - Instance Properties

    var jsonDecodingStrategy: JSONDecoder.DataDecodingStrategy {
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
