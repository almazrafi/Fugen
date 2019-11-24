import Foundation
import FugenTools

enum Dependencies {

    // MARK: - Type Properties

    static let figmaHTTPService: FigmaHTTPService = HTTPService()

    static let figmaAPIProvider: FigmaAPIProvider = DefaultFigmaAPIProvider(httpService: figmaHTTPService)
    static let figmaNodesProvider: FigmaNodesProvider = DefaultFigmaNodesProvider()

    static let colorStylesProvider: ColorStylesProvider = DefaultColorStylesProvider(
        apiProvider: figmaAPIProvider,
        nodesProvider: figmaNodesProvider
    )

    static let textStylesProvider: TextStylesProvider = DefaultTextStylesProvider(
        apiProvider: figmaAPIProvider,
        nodesProvider: figmaNodesProvider
    )

    static let assetsProvider: AssetsProvider = DefaultAssetsProvider()

    static let configurationProvider: ConfigurationProvider = DefaultConfigurationProvider()

    // MARK: -

    static let colorCoder: ColorCoder = DefaultColorCoder()
    static let fontCoder: FontCoder = DefaultFontCoder()

    static let colorStylesCoder: ColorStylesCoder = DefaultColorStylesCoder(colorCoder: colorCoder)

    static let textStylesCoder: TextStylesCoder = DefaultTextStylesCoder(
        fontCoder: fontCoder,
        colorCoder: colorCoder
    )

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
        assetsProvider: assetsProvider,
        colorStylesCoder: colorStylesCoder,
        templateRenderer: templateRenderer
    )

    static let textStylesGenerator: TextStylesGenerator = DefaultTextStylesGenerator(
        textStylesProvider: textStylesProvider,
        textStylesCoder: textStylesCoder,
        templateRenderer: templateRenderer
    )

    static let kitGenerator: KitGenerator = DefaultKitGenerator(
        configurationProvider: configurationProvider,
        colorStylesGenerator: colorStylesGenerator,
        textStylesGenerator: textStylesGenerator
    )
}
