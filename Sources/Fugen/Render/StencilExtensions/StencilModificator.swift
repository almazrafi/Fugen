//
//  StencilModificator.swift
//  Fugen
//
//  Created by Timur Shafigullin on 05.10.2020.
//

import Foundation
import FugenTools

protocol StencilModificator: StencilExtension {

    // MARK: - Nested Types

    associatedtype Input
    associatedtype Output

    // MARK: - Instance Methods

    func modify(input: Input, withArguments arguments: [Any?]) throws -> Output
}

extension StencilModificator {

    // MARK: - Instance Methods

    func register(in extensionRegistry: ExtensionRegistry) {
        extensionRegistry.registerFilter(name, filter: { value, parameters in
            guard let input = value as? Input else {
                throw StencilModificatorError(code: .invalidValue(value), filter: name)
            }

            return try self.modify(input: input, withArguments: parameters)
        })
    }
}

extension StencilModificator {

    // MARK: - Instance Methods

    func parseBool(from arguments: [Any?], at index: Int = 0) throws -> Bool {
        guard let rawArgument = arguments[safe: index] as? String else {
            throw StencilModificatorError(code: .invalidArguments(arguments), filter: name)
        }

        switch rawArgument.lowercased() {
        case "false", "no", "0":
            return false

        case "true", "yes", "1":
            return true

        default:
            throw StencilModificatorError(code: .invalidArguments(arguments), filter: name)
        }
    }
}
