import XCTest
import FugenTools

final class DictionaryEncoderTests: XCTestCase {

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

    func testThatEncoderSucceedsWhenEncodingEmptyDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: String] = [:]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToBoolDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary = ["foo": true, "bar": false]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToIntDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary = ["foo": 123, "bar": -456]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToInt8Dictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: Int8] = ["foo": 12, "bar": -34]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToInt16Dictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: Int16] = ["foo": 123, "bar": -456]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToInt32Dictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: Int32] = ["foo": 123, "bar": -456]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToInt64Dictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: Int64] = ["foo": 123, "bar": -456]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUIntDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: UInt] = ["foo": 123, "bar": 456]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUInt8Dictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: UInt8] = ["foo": 12, "bar": 34]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUInt16Dictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: UInt16] = ["foo": 123, "bar": 456]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUInt32Dictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: UInt32] = ["foo": 123, "bar": 456]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUInt64Dictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: UInt64] = ["foo": 123, "bar": 456]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToDoubleDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary = ["foo": 1.23, "bar": -45.6]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToFloatDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: Float] = ["foo": 1.23, "bar": -45.6]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToStringDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary = ["foo": "qwe", "bar": "asd"]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToArrayDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary: [String: [Int?]] = ["foo": [1, 2, 3], "bar": [4, nil, 6]]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingNestedStringToIntDictionary() {
        let encoder = DictionaryEncoder()
        let dictionary = ["foo": ["bar": 123, "baz": -456]]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
    }

    func testThatEncoderSucceedsWhenEncodingNestedArrayOfStringToIntDictionaries() {
        let encoder = DictionaryEncoder()
        let dictionary = ["foo": [["bar": 123, "baz": 456]]]

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: dictionary)),
            NSDictionary(dictionary: try encoder.encode(dictionary))
        )
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

    // MARK: -

    func testThatEncoderSucceedsWhenEncodingEmptyStruct() {
        struct EncodableStruct: Encodable { }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructWithMultipleProperties() {
        struct EncodableStruct: Encodable {
            let foo = true
            let bar: Int? = 123
            let baz: Int? = nil
            let bat = "qwe"
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructWithNestedStruct() {
        struct EncodableStruct: Encodable {
            struct NestedStruct: Encodable {
                let bar = 123
                let baz = 456
            }

            let foo = NestedStruct()
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructWithNestedEnum() {
        struct EncodableStruct: Encodable {
            enum NestedEnum: String, Encodable {
                case qwe
                case asd
            }

            let foo = NestedEnum.qwe
            let bar = NestedEnum.asd
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructInSeparateUnkeyedContainers() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            let bar = 123
            let baz = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                var barContainer = container.nestedUnkeyedContainer(forKey: .foo)
                var bazContainer = container.nestedUnkeyedContainer(forKey: .foo)

                try barContainer.encode(bar)
                try bazContainer.encode(baz)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructInSeparateKeyedContainers() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case bar
                case baz
            }

            let bar = 123
            let baz = 456

            func encode(to encoder: Encoder) throws {
                var barContainer = encoder.container(keyedBy: CodingKeys.self)
                var bazContainer = encoder.container(keyedBy: CodingKeys.self)

                try barContainer.encode(bar, forKey: .bar)
                try bazContainer.encode(baz, forKey: .baz)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructInSeparateKeyedContainersOfUnkeyedContainer() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            enum BarCodingKeys: String, CodingKey {
                case bar
            }

            enum BazCodingKeys: String, CodingKey {
                case baz
            }

            let bar = 123
            let baz = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .foo)

                var barContainer = unkeyedContainer.nestedContainer(keyedBy: BarCodingKeys.self)
                var bazContainer = unkeyedContainer.nestedContainer(keyedBy: BazCodingKeys.self)

                try barContainer.encode(bar, forKey: .bar)
                try bazContainer.encode(baz, forKey: .baz)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructInSeparateNestedKeyedContainers() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            struct NestedStruct {
                enum CodingKeys: String, CodingKey {
                    case bar
                    case baz
                }

                let bar = 123
                let baz = 456
            }

            let foo = NestedStruct()

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                var barContainer = container.nestedContainer(keyedBy: NestedStruct.CodingKeys.self, forKey: .foo)
                var bazContainer = container.nestedContainer(keyedBy: NestedStruct.CodingKeys.self, forKey: .foo)

                try barContainer.encode(foo.bar, forKey: .bar)
                try bazContainer.encode(foo.baz, forKey: .baz)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingSubclass() {
        class EncodableClass: Encodable {
            let foo = "qwe"
            let bar = "asd"
        }

        class EncodableSubclass: EncodableClass {
            enum CodingKeys: String, CodingKey {
                case baz
                case bat
            }

            let baz = 123
            let bat = 456

            override func encode(to encoder: Encoder) throws {
                try super.encode(to: encoder)

                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(baz, forKey: .baz)
                try container.encode(bat, forKey: .bat)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableSubclass()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingSubclassUsingSuperEncoder() {
        class EncodableClass: Encodable {
            let foo = "qwe"
            let bar = "asd"
        }

        class EncodableSubclass: EncodableClass {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
                case baz
                case bat
            }

            let baz = 123
            let bat = 456

            override func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(baz, forKey: .baz)
                try container.encode(bat, forKey: .bat)

                let superEncoder = container.superEncoder()
                var superContainer = superEncoder.container(keyedBy: CodingKeys.self)

                try superContainer.encode(foo, forKey: .foo)
                try superContainer.encode(bar, forKey: .bar)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableSubclass()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingSubclassUsingSuperEncoderForKeys() {
        class EncodableClass: Encodable {
            let foo = "qwe"
            let bar = "asd"
        }

        class EncodableSubclass: EncodableClass {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
                case baz
                case bat
            }

            let baz = 123
            let bat = 456

            override func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(baz, forKey: .baz)
                try container.encode(bat, forKey: .bat)

                let fooSuperEncoder = container.superEncoder(forKey: .foo)
                let barSuperEncoder = container.superEncoder(forKey: .bar)

                var fooContainer = fooSuperEncoder.container(keyedBy: CodingKeys.self)
                var barContainer = barSuperEncoder.container(keyedBy: CodingKeys.self)

                try fooContainer.encode(foo, forKey: .foo)
                try barContainer.encode(bar, forKey: .bar)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableSubclass()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    func testThatEncoderSucceedsWhenEncodingSubclassUsingSuperEncoderOfNestedUnkeyedContainer() {
        class EncodableClass: Encodable {
            let foo = "qwe"
            let bar = "asd"
        }

        class EncodableSubclass: EncodableClass {
            enum CodingKeys: String, CodingKey {
                case baz
            }

            let baz = 123
            let bat = 456

            override func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                var bazContainer = container.nestedUnkeyedContainer(forKey: .baz)
                var batContainer = bazContainer.nestedUnkeyedContainer()

                try bazContainer.encode(baz)
                try batContainer.encode(bat)

                let bazSuperEncoder = bazContainer.superEncoder()

                var fooContainer = bazSuperEncoder.unkeyedContainer()
                var barContainer = bazSuperEncoder.unkeyedContainer()

                try fooContainer.encode(foo)
                try barContainer.encode(bar)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableSubclass()

        XCTAssertEqual(
            NSDictionary(dictionary: try makeExpectedDictionary(for: value)),
            NSDictionary(dictionary: try encoder.encode(value))
        )
    }

    // MARK: -

    func testThatEncoderFailsWhenEncodingArray() {
        let encoder = DictionaryEncoder()
        let array = [1, 2, 3]

        do {
            _ = try encoder.encode(array)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let EncodingError.invalidValue(invalidValue as [Int], _):
                XCTAssertEqual(invalidValue, array)

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatEncoderFailsWhenEncodingSingleValue() {
        let encoder = DictionaryEncoder()
        let number = 123

        do {
            _ = try encoder.encode(number)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let EncodingError.invalidValue(invalidValue as Int, _):
                XCTAssertEqual(invalidValue, number)

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatEncoderFailsWhenEncodingMultipleSingleValuesForKey() {
        struct EncodableStruct: Encodable {
            let foo = 123
            let bar = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                try container.encode(foo)
                try container.encode(bar)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        do {
            _ = try encoder.encode(value)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let EncodingError.invalidValue(invalidValue as Int, _):
                XCTAssertEqual(invalidValue, value.bar)

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
        }
    }

    func testThatEncoderFailsWhenEncodingWithMultipleSingleValueContainers() {
        struct EncodableStruct: Encodable {
            let foo = 123
            let bar = 456

            func encode(to encoder: Encoder) throws {
                var fooContainer = encoder.singleValueContainer()
                var barContainer = encoder.singleValueContainer()

                try fooContainer.encode(foo)
                try barContainer.encode(bar)
            }
        }

        let encoder = DictionaryEncoder()
        let value = EncodableStruct()

        do {
            _ = try encoder.encode(value)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            switch error {
            case let EncodingError.invalidValue(invalidValue as Int, _):
                XCTAssertEqual(invalidValue, value.bar)

            default:
                XCTFail("Test encountered unexpected error: \(error)")
            }
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
