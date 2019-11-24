import Foundation
import PromiseKit

protocol FigmaFilesProvider {

    // MARK: - Instance Methods

    func fetchFile(key: String, version: String?, accessToken: String) -> Promise<FigmaFile>
}
