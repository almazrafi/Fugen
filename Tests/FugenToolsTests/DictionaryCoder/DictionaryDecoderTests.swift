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
        decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy.jsonDecodingStrategy

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

    // MARK: -

    func testThatDecoderFailsWhenDecodingNonConformingFloat() {
        let nonConformingFloatDecodingStrategy = DictionaryNonConformingFloatDecodingStrategy.throw
        let decoder = DictionaryDecoder(nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy)
        let dictionary = ["foo": Float.infinity, "bar": -Float.infinity, "baz": Float.nan]
        let valueType = [String: Float].self

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

    func testThatDecoderSucceedsWhenDecodingNonConformingFloatFromString() {
        let nonConformingFloatDecodingStrategy = DictionaryNonConformingFloatDecodingStrategy.convertFromString(
            positiveInfinity: "+∞",
            negativeInfinity: "-∞",
            nan: "¬"
        )

        let decoder = DictionaryDecoder(nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy)
        let dictionary = ["foo": "+∞", "bar": "-∞", "baz": "¬"]
        let valueType = [String: Float].self

        do {
            let expectedValue = try makeExpectedValue(
                valueType,
                from: dictionary,
                nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy
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

    func testThatDecoderFailsWhenDecodingNonConformingFloatFromInvalidString() {
        let nonConformingFloatDecodingStrategy = DictionaryNonConformingFloatDecodingStrategy.convertFromString(
            positiveInfinity: "+∞",
            negativeInfinity: "-∞",
            nan: "¬"
        )

        let decoder = DictionaryDecoder(nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy)
        let dictionary = ["foo": "123", "bar": "456", "baz": "789"]
        let valueType = [String: Float].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Float.Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderFailsWhenDecodingFloatFromWrongType() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foobar": true]
        let valueType = [String: Float].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Float.Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderFailsWhenDecodingFloatFromNil() {
        let decoder = DictionaryDecoder()
        let dictionary: [String: [Float?]] = ["foobar": [1.23, nil]]
        let valueType = [String: [Float]].self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Float.Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    // MARK: -

    func testThatDecoderSucceedsWhenDecodingEmptyStruct() {
        struct DecodableStruct: Decodable, Equatable { }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = [:]
        let valueType = DecodableStruct.self

        XCTAssertEqual(
            try makeExpectedValue(valueType, from: dictionary),
            try decoder.decode(valueType, from: dictionary)
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructWithMultipleProperties() {
        struct DecodableStruct: Decodable, Equatable {
            let foo = true
            let bar: Int? = 123
            let baz: Int? = nil
            let bat = "qwe"
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": true, "bar": 123, "bat": "qwe"]
        let valueType = DecodableStruct.self

        XCTAssertEqual(
            try makeExpectedValue(valueType, from: dictionary),
            try decoder.decode(valueType, from: dictionary)
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructWithNestedStruct() {
        struct DecodableStruct: Decodable, Equatable {
            struct NestedStruct: Decodable, Equatable {
                let bar = 123
                let baz = 456
            }

            let foo: NestedStruct
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": ["bar": 123, "baz": 456]]
        let valueType = DecodableStruct.self

        XCTAssertEqual(
            try makeExpectedValue(valueType, from: dictionary),
            try decoder.decode(valueType, from: dictionary)
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructWithNestedEnum() {
        struct DecodableStruct: Decodable, Equatable {
            enum NestedEnum: String, Decodable {
                case qwe
                case asd
            }

            let foo: NestedEnum
            let bar: NestedEnum
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": "qwe", "bar": "asd"]
        let valueType = DecodableStruct.self

        XCTAssertEqual(
            try makeExpectedValue(valueType, from: dictionary),
            try decoder.decode(valueType, from: dictionary)
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateKeyedContainers() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let barContainer = try decoder.container(keyedBy: CodingKeys.self)
                let bazContainer = try decoder.container(keyedBy: CodingKeys.self)

                foo = try barContainer.decode(Int.self, forKey: .foo)
                bar = try bazContainer.decode(Int.self, forKey: .bar)
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": 123, "bar": 456]
        let valueType = DecodableStruct.self

        XCTAssertEqual(
            try makeExpectedValue(valueType, from: dictionary),
            try decoder.decode(valueType, from: dictionary)
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateUnkeyedContainers() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            let bar: Int
            let baz: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                var barContainer = try container.nestedUnkeyedContainer(forKey: .foo)
                var bazContainer = try container.nestedUnkeyedContainer(forKey: .foo)

                bar = try barContainer.decode(Int.self)
                baz = try bazContainer.decode(Int.self)
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": [123, 456]]
        let valueType = DecodableStruct.self

        XCTAssertEqual(
            try makeExpectedValue(valueType, from: dictionary),
            try decoder.decode(valueType, from: dictionary)
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateKeyedContainersOfUnkeyedContainer() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            enum BarCodingKeys: String, CodingKey {
                case bar
            }

            enum BazCodingKeys: String, CodingKey {
                case baz
            }

            let bar: Int
            let baz: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .foo)

                let barContainer = try unkeyedContainer.nestedContainer(keyedBy: BarCodingKeys.self)
                let bazContainer = try unkeyedContainer.nestedContainer(keyedBy: BazCodingKeys.self)

                bar = try barContainer.decode(Int.self, forKey: .bar)
                baz = try bazContainer.decode(Int.self, forKey: .baz)
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": [["bar": 123], ["baz": 456]]]
        let valueType = DecodableStruct.self

        XCTAssertEqual(
            try makeExpectedValue(valueType, from: dictionary),
            try decoder.decode(valueType, from: dictionary)
        )
    }

    func testThatDecoderSucceedsWhenDecodingStructInSeparateNestedKeyedContainers() {
        struct DecodableStruct: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            struct NestedStruct: Equatable {
                enum CodingKeys: String, CodingKey {
                    case bar
                    case baz
                }

                let bar: Int
                let baz: Int
            }

            let foo: NestedStruct

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let barContainer = try container.nestedContainer(keyedBy: NestedStruct.CodingKeys.self, forKey: .foo)
                let bazContainer = try container.nestedContainer(keyedBy: NestedStruct.CodingKeys.self, forKey: .foo)

                foo = NestedStruct(
                    bar: try barContainer.decode(Int.self, forKey: .bar),
                    baz: try bazContainer.decode(Int.self, forKey: .baz)
                )
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": ["bar": 123, "baz": 456]]
        let valueType = DecodableStruct.self

        XCTAssertEqual(
            try makeExpectedValue(valueType, from: dictionary),
            try decoder.decode(valueType, from: dictionary)
        )
    }

    func testThatDecoderSucceedsWhenDecodingSubclass() {
        class DecodableClass: Decodable {
            let foo: String
        }

        class DecodableSubclass: DecodableClass {
            enum CodingKeys: String, CodingKey {
                case bar
                case baz
            }

            let bar: Int
            let baz: Int

            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                bar = try container.decode(Int.self, forKey: .bar)
                baz = try container.decode(Int.self, forKey: .baz)

                try super.init(from: decoder)
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": "qwe", "bar": 123, "baz": 456]
        let valueType = DecodableSubclass.self

        do {
            let expectedValue = try makeExpectedValue(valueType, from: dictionary)
            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(expectedValue.foo, decodedValue.foo)
            XCTAssertEqual(expectedValue.bar, decodedValue.bar)
            XCTAssertEqual(expectedValue.baz, decodedValue.baz)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderSucceedsWhenDecodingSubclassUsingSuperDecoder() {
        class DecodableClass: Decodable {
            let foo: String

            init(foo: String) {
                self.foo = foo
            }
        }

        class DecodableSubclass: DecodableClass {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let bar: Int

            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                bar = try container.decode(Int.self, forKey: .bar)

                let superDecoder = try container.superDecoder()
                let superContainer = try superDecoder.container(keyedBy: CodingKeys.self)

                super.init(foo: try superContainer.decode(String.self, forKey: .foo))
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["super": ["foo": "qwe"], "bar": 123]
        let valueType = DecodableSubclass.self

        do {
            let expectedValue = try makeExpectedValue(valueType, from: dictionary)
            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(expectedValue.foo, decodedValue.foo)
            XCTAssertEqual(expectedValue.bar, decodedValue.bar)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderSucceedsWhenDecodingSubclassUsingSuperDecoderForKeys() {
        class DecodableClass: Decodable {
            let foo: String
            let bar: String

            init(foo: String, bar: String) {
                self.foo = foo
                self.bar = bar
            }
        }

        class DecodableSubclass: DecodableClass {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
                case baz
            }

            let baz: Int

            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                baz = try container.decode(Int.self, forKey: .baz)

                let fooSuperDecoder = try container.superDecoder(forKey: .foo)
                let barSuperDecoder = try container.superDecoder(forKey: .bar)

                let fooContainer = try fooSuperDecoder.container(keyedBy: CodingKeys.self)
                let barContainer = try barSuperDecoder.container(keyedBy: CodingKeys.self)

                super.init(
                    foo: try fooContainer.decode(String.self, forKey: .foo),
                    bar: try barContainer.decode(String.self, forKey: .bar)
                )
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["foo": ["foo": "qwe"], "bar": ["bar": "asd"], "baz": 123]
        let valueType = DecodableSubclass.self

        do {
            let expectedValue = try makeExpectedValue(valueType, from: dictionary)
            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(expectedValue.foo, decodedValue.foo)
            XCTAssertEqual(expectedValue.bar, decodedValue.bar)
            XCTAssertEqual(expectedValue.baz, decodedValue.baz)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatDecoderSucceedsWhenDecodingSubclassUsingSuperDecoderOfNestedUnkeyedContainer() {
        class DecodableClass: Decodable {
            let foo: String
            let bar: String

            init(foo: String, bar: String) {
                self.foo = foo
                self.bar = bar
            }
        }

        class DecodableSubclass: DecodableClass {
            enum CodingKeys: String, CodingKey {
                case baz
            }

            let baz: Int
            let bat: Int

            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                var bazContainer = try container.nestedUnkeyedContainer(forKey: .baz)
                var batContainer = try bazContainer.nestedUnkeyedContainer()

                baz = try bazContainer.decode(Int.self)
                bat = try batContainer.decode(Int.self)

                let bazSuperDecoder = try bazContainer.superDecoder()

                var fooContainer = try bazSuperDecoder.unkeyedContainer()
                var barContainer = try bazSuperDecoder.unkeyedContainer()

                super.init(
                    foo: try fooContainer.decode(String.self),
                    bar: try barContainer.decode(String.self)
                )
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary: [String: Any] = ["baz": [[123], 345, ["qwe"]]]
        let valueType = DecodableSubclass.self

        do {
            let expectedValue = try makeExpectedValue(valueType, from: dictionary)
            let decodedValue = try decoder.decode(valueType, from: dictionary)

            XCTAssertEqual(expectedValue.foo, decodedValue.foo)
            XCTAssertEqual(expectedValue.bar, decodedValue.bar)
            XCTAssertEqual(expectedValue.baz, decodedValue.baz)
            XCTAssertEqual(expectedValue.bat, decodedValue.bat)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    // MARK: -

    func testThatDecoderFailsWhenDecodingArray() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foobar": 123]
        let valueType = [Int].self

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

    func testThatDecoderFailsWhenDecodingSingleValue() {
        let decoder = DictionaryDecoder()
        let dictionary = ["foobar": 123]
        let valueType = Int.self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is Int.Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderFailsWhenDecodingNilForKeyedContainer() {
        struct DecodableStruct: Decodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder(forKey: .foo)
                let superContainer = try superDecoder.container(keyedBy: CodingKeys.self)

                foo = try superContainer.decode(Int.self, forKey: .foo)
                bar = try superContainer.decode(Int.self, forKey: .bar)
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary = ["foobar": 123]
        let valueType = DecodableStruct.self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [String: Any].Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderFailsWhenDecodingInvalidForKeyedContainer() {
        struct DecodableStruct: Decodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder(forKey: .foo)
                let superContainer = try superDecoder.container(keyedBy: CodingKeys.self)

                foo = try superContainer.decode(Int.self, forKey: .foo)
                bar = try superContainer.decode(Int.self, forKey: .bar)
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary = ["foo": 123]
        let valueType = DecodableStruct.self

        do {
            _ = try decoder.decode(valueType, from: dictionary)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let DecodingError.typeMismatch(type, _) where type is [String: Any].Type:
                break

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatDecoderFailsWhenDecodingNilForUnkeyedContainer() {
        struct DecodableStruct: Decodable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder(forKey: .foo)
                var superContainer = try superDecoder.unkeyedContainer()

                foo = try superContainer.decode(Int.self)
                bar = try superContainer.decode(Int.self)
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary = ["foobar": 123]
        let valueType = DecodableStruct.self

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

    func testThatDecoderFailsWhenDecodingInvalidForUnkeyedContainer() {
        struct DecodableStruct: Decodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo: Int
            let bar: Int

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let superDecoder = try container.superDecoder(forKey: .foo)
                var superContainer = try superDecoder.unkeyedContainer()

                foo = try superContainer.decode(Int.self)
                bar = try superContainer.decode(Int.self)
            }
        }

        let decoder = DictionaryDecoder()
        let dictionary = ["foo": 123]
        let valueType = DecodableStruct.self

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

private extension DictionaryNonConformingFloatDecodingStrategy {

    // MARK: - Instance Properties

    var jsonDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        switch self {
        case let .convertFromString(positiveInfinity, negativeInfinity, nan):
            return .convertFromString(
                positiveInfinity: positiveInfinity,
                negativeInfinity: negativeInfinity,
                nan: nan
            )

        case .throw:
            return .throw
        }
    }
}
