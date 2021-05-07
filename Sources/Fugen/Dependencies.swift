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

    static let shadowStylesProvider: ShadowStylesProvider = DefaultShadowStylesProvider(
        filesProvider: figmaFilesProvider,
        nodesProvider: figmaNodesProvider
    )

    // MARK: -

    static let templateContextCoder: TemplateContextCoder = DefaultTemplateContextCoder()

    static let stencilExtensions: [StencilExtension] = [
        StencilByteToHexFilter(),
        StencilHexToByteFilter(),
        StencilByteToFloatFilter(),
        StencilFloatToByteFilter(),
        StencilVectorInfoFilter(contextCoder: templateContextCoder),
        StencilColorRGBHexInfoFilter(contextCoder: templateContextCoder),
        StencilColorRGBAHexInfoFilter(contextCoder: templateContextCoder),
        StencilColorRGBInfoFilter(contextCoder: templateContextCoder),
        StencilColorRGBAInfoFilter(contextCoder: templateContextCoder),
        StencilColorInfoFilter(contextCoder: templateContextCoder),
        StencilFontInfoFilter(contextCoder: templateContextCoder),
        StencilFontInitializerModificator(contextCoder: templateContextCoder),
        StencilFontSystemFilter(contextCoder: templateContextCoder)
    ]

    static let templateRenderer: TemplateRenderer = DefaultTemplateRenderer(
        contextCoder: templateContextCoder,
        stencilExtensions: stencilExtensions
    )

    // MARK: -

    static let colorStylesGenerator: ColorStylesGenerator = DefaultColorStylesGenerator(
        colorStylesProvider: colorStylesProvider,
        templateRenderer: templateRenderer
    )

    static let textStylesGenerator: TextStylesGenerator = DefaultTextStylesGenerator(
        textStylesProvider: textStylesProvider,
        templateRenderer: templateRenderer
    )

    static let imagesGenerator: ImagesGenerator = DefaultImagesGenerator(
        imagesProvider: imagesProvider,
        templateRenderer: templateRenderer
    )

    static let shadowStylesGenerator: ShadowStylesGenerator = DefaultShadowStylesGenerator(
        shadowStylesProvider: shadowStylesProvider,
        templateRenderer: templateRenderer
    )

    static let libraryGenerator: LibraryGenerator = DefaultLibraryGenerator(
        configurationProvider: configurationProvider,
        colorStylesGenerator: colorStylesGenerator,
        textStylesGenerator: textStylesGenerator,
        imagesGenerator: imagesGenerator,
        shadowStylesGenerator: shadowStylesGenerator
    )
}
