import Foundation

internal final class URLEncodedFormContext {

    // MARK: - Instance Properties

    internal var component: URLEncodedFormComponent

    // MARK: - Initializers

    internal init(component: URLEncodedFormComponent) {
        self.component = component
    }
}
