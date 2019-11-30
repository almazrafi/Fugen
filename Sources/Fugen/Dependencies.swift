import Foundation
import FugenTools

enum Dependencies {

    // MARK: - Type Properties

    static let dataProvider: DataProvider = DefaultDataProvider()

    static let figmaHTTPService: FigmaHTTPService = HTTPService()
    static let figmaAPIProvider: FigmaAPIProvider = DefaultFigmaAPIProvider(httpService: figmaHTTPService)

    static let figmaFilesProvider: FigmaFilesProvider = DefaultFigmaFilesProvider(apiProvider: figmaAPIProvider)
    static let figmaNodesProvider: FigmaNodesProvider = DefaultFigmaNodesProvider()

    static let assetsProvider: AssetsProvider = DefaultAssetsProvider()

    static let colorStyleAssetsProvider: ColorStyleAssetsProvider = DefaultColorStyleAssetsProvider(
        assetsProvider: assetsProvider
    )

    static let colorStylesProvider: ColorStylesProvider = DefaultColorStylesProvider(
        filesProvider: figmaFilesProvider,
        nodesProvider: figmaNodesProvider,
        colorStyleAssetsProvider: colorStyleAssetsProvider
    )

    static let textStylesProvider: TextStylesProvider = DefaultTextStylesProvider(
        filesProvider: figmaFilesProvider,
        nodesProvider: figmaNodesProvider
    )

    static let imageRenderProvider: ImageRenderProvider = DefaultImageRenderProvider(apiProvider: figmaAPIProvider)

    static let imageAssetsProvider: ImageAssetsProvider = DefaultImageAssetsProvider(
        assetsProvider: assetsProvider,
        dataProvider: dataProvider
    )

    static let imageResourcesProvider: ImageResourcesProvider = DefaultImageResourcesProvider(
        dataProvider: dataProvider
    )

    static let imagesProvider: ImagesProvider = DefaultImagesProvider(
        filesProvider: figmaFilesProvider,
        nodesProvider: figmaNodesProvider,
        imageRenderProvider: imageRenderProvider,
        imageAssetsProvider: imageAssetsProvider,
        imageResourcesProvider: imageResourcesProvider
    )

    static let configurationProvider: ConfigurationProvider = DefaultConfigurationProvider()

    // MARK: -

    static let colorCoder: ColorCoder = DefaultColorCoder()
    static let fontCoder: FontCoder = DefaultFontCoder()

    static let colorStylesCoder: ColorStylesCoder = DefaultColorStylesCoder(colorCoder: colorCoder)

    static let textStylesCoder: TextStylesCoder = DefaultTextStylesCoder(
        fontCoder: fontCoder,
        colorCoder: colorCoder
    )

    static let imagesCoder: ImagesCoder = DefaultImagesCoder()

    // MARK: -

    static let stencilExtensions: [StencilExtension] = [
        StencilByteToHexFilter(),
        StencilHexToByteFilter(),
        StencilByteToFloatFilter(),
        StencilFloatToByteFilter(),
        StencilColorRGBHexInfoFilter(colorCoder: colorCoder),
        StencilColorRGBAHexInfoFilter(colorCoder: colorCoder),
        StencilColorRGBInfoFilter(colorCoder: colorCoder),
        StencilColorRGBAInfoFilter(colorCoder: colorCoder),
        StencilColorInfoFilter(colorCoder: colorCoder),
        StencilFontInfoFilter(fontCoder: fontCoder)
    ]

    static let templateRenderer: TemplateRenderer = DefaultTemplateRenderer(stencilExtensions: stencilExtensions)

    // MARK: -

    static let colorStylesGenerator: ColorStylesGenerator = DefaultColorStylesGenerator(
        colorStylesProvider: colorStylesProvider,
        colorStylesCoder: colorStylesCoder,
        templateRenderer: templateRenderer
    )

    static let textStylesGenerator: TextStylesGenerator = DefaultTextStylesGenerator(
        textStylesProvider: textStylesProvider,
        textStylesCoder: textStylesCoder,
        templateRenderer: templateRenderer
    )

    static let imagesGenerator: ImagesGenerator = DefaultImagesGenerator(
        imagesProvider: imagesProvider,
        imagesCoder: imagesCoder,
        templateRenderer: templateRenderer
    )

    static let libraryGenerator: LibraryGenerator = DefaultLibraryGenerator(
        configurationProvider: configurationProvider,
        colorStylesGenerator: colorStylesGenerator,
        textStylesGenerator: textStylesGenerator,
        imagesGenerator: imagesGenerator
    )
}
