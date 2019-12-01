import Foundation
import PromiseKit

protocol FigmaFilesProvider {

    // MARK: - Instance Methods

    func fetchFile(_ file: FileParameters) -> Promise<FigmaFile>
}
