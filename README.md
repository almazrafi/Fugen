# Fugen
[![Travis CI](https://travis-ci.com/almazrafi/Fugen.svg?branch=master)](https://travis-ci.com/almazrafi/Fugen)
[![Version](https://img.shields.io/github/v/release/almazrafi/Fugen)](https://github.com/almazrafi/Fugen/releases)
[![Xcode](https://img.shields.io/badge/Xcode-11-blue.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20Linux-lightgrey)](https://swift.org/about/#platform-support)
[![License](https://img.shields.io/github/license/almazrafi/Fugen.svg?style=flat)](https://github.com/almazrafi/Fugen/blob/master/LICENSE)

Fugen is a command line tool that is used to generate code from [Figma](http://figma.com/) files,
completely written in [Swift](https://swift.org).

Currently, it supports generating the following entities:
- Color styles
- Text styles
- Images

#### Table of context
- [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Homebrew](#homebrew)
    - [ZIP archive](#zip-archive)
- [Usage](#usage)
- [Configuration](#configuration)
    - [Base parameters](#base-parameters)
    - [Figma access token](#figma-access-token)
    - [Figma file](#figma-file)
    - [Generation configuration](#generation-configuration)
- [Color styles](#color-styles)
- [Text styles](#text-styles)
- [Images](#images)
- [Communication](#communication)
- [License](#license)


## Installation:
### CocoaPods
To install Fugen using [CocoaPods](http://cocoapods.org) dependency manager, add the line to `Podfile`:
```ruby
pod 'Fugen', '~> 1.0.0'
```

Then run this command:
```sh
$ pod install --repo-update
```

**N.B.:** if installing using CocoaPods, the generate command should include a relative path to `Pods/Fugen` folder:
```sh
$ Pods/Fugen/fugen generate
```

> Installation via CocoaPods is recommended, as it allows to use the fixed version on all team members machines
> and automate the update process.

### Homebrew
For [Homebrew](https://brew.sh) dependency manager installation, run:
```sh
$ brew install almazrafi/tap/fugen
```

> It's impossible to set a specific package version via Homebrew.
> In case this method was chosen, it's recommended to control that all team members use the same version of Fugen.

### ZIP archive
Every release in the repo has a ZIP archive which can be used to integrate Fugen into a project.
For using that method, the following steps should be taken:
- Open [repository release page](https://github.com/almazrafi/Fugen/releases).
- Download an archive 'fugen-x.y.z.zip' attached to the latest release.
- Unarchive the ZIP into a convenient project folder

**N.B.:** if this integration method was chosen,
the generation command should include a relative path to the folder with the ZIP-archive content, for example:
```sh
$ MyFolder/fugen generate
```

> It's recommended to include unarchived files into the Git index (`git add MyFolder`).
> It will guarantee that all team members are using the same version of Fugen for the project.


## Usage
Fugen provides a simple command for code generation:
```sh
$ fugen generate
```
As the result, the source code files will be received according to the configuration (see [Configuration](#configuration)),
which by default should be placed to `.fugen.yml` file.

A specific path to the configuration could be used by passing it in `--config` parameter if needed, for example:
```sh
$ fugen generate --config 'Folder/fugen.yml'
```

Fugen requests files data using [Figma API](https://www.figma.com/developers/api),
so the internet connection is necessary to generate the code.

The resulting code could be easily customized with [Stencil-templates](https://github.com/stencilproject/Stencil).
If standard templates are not enough, a custom template could be used,
specify its path in the [configuration](#configuration).

### Integration
There is no point to run `fugen generate` at the build stage, as Fugen doesn't work with local resources,
which can be changed during development. All data for code generation is in Figma.
Also, there will be no merge conflicts, if using design versioning.

Because of that, it is much better to generate code just once and keep it in the Git index,
while running `fugen generate` when necessary:
- to upgrade to a new design version in Figma
- after updating Fugen version

There are also certain recommendations for integration, taking into account the technologies used in the project,
all of them are listed in this section and will be updated as feedback is received

In case you have any difficulties or wishes related to integration,
please open the corresponding request in [Issues](https://github.com/almazrafi/Fugen/issues).

#### CocoaPods
If using [CocoaPods](http://cocoapods.org) dependency manager,
it's recommended to run code generating command from `pre-install` event handler in `Podfile`:
```ruby
pre_install do |installer|
  system "Pods/Fugen/fugen generate"
end
```

That will allow connecting the code generation command with updating Fugen version
and will reduce the number of commands executed while cloning the project.

**N.B.:** This integration is ideal if the generated files should be held in the Development Pod,
as in this case the generation should be run after loading Fugen and before installing all Pods.
Otherwise, new files will not be indexed on time and won't get included into the Xcode-project.

## Configuration
[YAML](https://yaml.org) file is used for Fugen configuration.
In this file all necessary parameters of code generation should be defined.

Configuration is divided into several sections:
- `base`: base parameters that are actual for all other configuration sections (see [Base parameters](#base-parameters)
- `colorStyles`: parameters of color styles generation step (see [Color styles](#color-styles)).
- `textStyles`: parameters of text styles generation step (see [Text styles](#text-styles)).
- `images`: parameters of the step of loading and generating code for images (see [Images](#images)).

Any parameter from `base` section will be inherited and could be overwritten in the section of the particular generation step.
If some section of the generation step is missing in the configuration,
it will be skipped during `fugen generate` command execution.

### Base parameters
Each step of generation is using the following base parameters:
- `accessToken`: an access token string that is needed to execute Figma API requests (see [Figma access token](#figma-access-token)).
- `file`: URL of a Figma file, which data will be used to generate code (see [Figma file](#figma-file)).

In order not to duplicate these fields in the configuration, they can be specified in the `base` section.
Then they will be used by those generation steps for which these parameters are not defined.
For example:
```yaml
base:
  accessToken: '25961-4ac9fbc9-3bd8-4c43-bbe2-95e477f8a067'
  file: 'https://www.figma.com/file/61xw2FQn61Xr7VVFYwiHHy/Fugen-Demo'

colorStyles: { }

textStyles:
  file: 'https://www.figma.com/file/SSeboI2x0jmeG4QO8iBMqX/Fugen-Demo-iOS'
```

If base parameters are missing for both the generation step section and in the `base` section,
then as a result of the execution `fugen generate` command, the corresponding error will be received.

### Figma access token
Authorization is required to receive Figma files.
The authorization is implemented by transferring a personal access token.
This token could be created in a few simple steps:
1. Open [account settings]((https://www.figma.com/settings)) in Figma.
2. Press "Create a new personal access token" button in the "Personal Access Tokens" section.
3. Enter a description for the token (for instance, "Fugen").
4. Copy the created token to the clipboard.

![](Assets/AccessToken.png)

Then paste the received access token in the `accessToken` field of the configuration.
It is enough to define it only in the `base` section if this token allows access to all Figma files,
which appear in the configuration.
For example:
```yaml
base:
  accessToken: '25961-4ac9fbc9-3bd8-4c43-bbe2-95e477f8a067'
...
```

If for a certain file you need to use a different access token,
it should be specified in the corresponding section of the configuration (see [Base parameters](#base-parameters)).

### Figma file
Fugen requests Figma file, using the identifier from its URL, which should be placed in a `file`  field of configuration.
For example:
```yaml
base:
  file: 'https://www.figma.com/file/61xw2FQn61Xr7VVFYwiHHy/Fugen-Demo'
...
```

In addition to the file identifier itself, the URL could also contain additional parameters
and generally has the following format:
```url
https://www.figma.com/file/:id/:title?version-id=:version-id&node-id=:node-id
```

To get the file, the following parameters are used:
- `id`: the identifier of the file.
- `version-id`: the identifier of the file version.
If this parameter is omitted, the current version will be used.
- `node-id`: identifier of the selected frame.
If this parameter is present, then only the data from this frame will be used.

The URL of the Figma file opened in the browser can be easily obtained from the address bar.

![](Assets/FileURL.png)

**N.B.:** Be careful with the `node-id` parameter, as in Figma the wrong frame could be selected.
Then the wrong data will be used for generation.

#### Alternative configuration
Sometimes using the file URL is not flexible enough.
Then instead of URL parameter in `file`, an object with the following fields can be defined:
- `key`: a string with the file's identifier. Is required.
- `version`: a string with the file's version.
If this parameter is omitted, the current file version will be used.
- `includedNodes`: an array of strings with nodes identifiers, that should be used for code generation.
If this parameter is omitted, all file nodes will be used.
- `excludedNodes`: an array of strings with nodes identifiers that should be ignored when generating the code.
If this parameter is omitted, all file nodes specified in the `includedNodes` field will be used.

The values for these fields must be manually extracted from the file URL, according to its format.
For example, for URL  `https://www.figma.com/file/61xw2FQn61Xr7VVFYwiHHy/Fugen-Demo?version-id=194665614&node-id=0%3A1`
the configuration will look like:
```yaml
base:
  file:
    key: '61xw2FQn61Xr7VVFYwiHHy'
    version: '201889163'
    includedNodes:
      - '0%3A1'
...
```

Such a representation may be useful for implementing more complex filtering of nodes.
For example, when it is necessary to exclude several elements specific to another platform from the code generation.

### Generation configuration
Besides [base parameters](#base-parameters),
for each step of the generation the following configuration should be defined:
- `template`: a path to the Stencil-template file.
If omitted, the standard template will be used.
- `templateOptions`: a dictionary with additional options that will be used for generation in Stencil-template.
- `destination`: a path to save the generated file.
If omitted, the generated code will be displayed in the console.

These generation steps also could have additional parameters.
The description of them and examples could be found in corresponding sections below.

---

## Color styles
To generate color styles [standard configuration set](#generation-configuration) is used with an additional parameter:
- `assets`: a path to Xcode assets folder, in which all colors will be saved as Color Set.
The parameter can be omitted if there is no need for assets.

Sample configuration:
```yaml
colorStyles:
  accessToken: '25961-4ac9fbc9-3bd8-4c43-bbe2-95e477f8a067'
  file: 'https://www.figma.com/file/61xw2FQn61Xr7VVFYwiHHy/Fugen-Demo'
  assets: 'Sources/Assets.xcasset/Colors'
  destination: 'Sources/ColorStyle.swift'
  templateOptions:
    publicAccess: true
```

#### Xcode-assets
It's recommended to specify the path to a subfolder inside the Xcode-assets folder in the  `assets` parameter,
so all colors are saved in this subfolder. For example `Sources/Assets.xcasset/Colors`.
The whole assets structure be created if it was missing.

**N.B.:** Folder specified in the `assets` parameter will be emptied before saving colors there.
You shouldn't use the same path for different generation steps,
but you can use different subfolders of the assets folder,
for example `Sources/Assets.xcasset/Colors` and `Sources/Assets.xcasset/Images`.

#### Standard template
Examples of usage of the generated code:
```swift
view.backgroundColor = ColorStyle.razzmatazz.color
// or
view.backgroundColor = UIColor(style: .razzmatazz)
```

The template could be configured using different options that are specified in `templateOptions` parameter:

Key  | Type | Default value | Description
---- | -----| ------------- | -----------
`styleTypeName` | string | ColorStyle | Style type name
`colorTypeName` | string | UICOlor | Color type name. If the target platform is macOS, specify `NSColor`.
`publicAccess` | flag | false | Flag that adds `public` access modifier to the declarations in the generated file.

## Text styles
To generate text styles [standard configuration set](#generation-configuration) is used.

Sample configuration:
```yaml
textStyles:
  accessToken: '25961-4ac9fbc9-3bd8-4c43-bbe2-95e477f8a067'
  file: 'https://www.figma.com/file/61xw2FQn61Xr7VVFYwiHHy/Fugen-Demo'
  destination: 'Sources/TextStyle.swift'
  templateOptions:
    publicAccess: true
```

#### Standard template
Sample usage of the generated code:
```swift
label.attributedText = TextStyle.title.attributetemplateOptionsdString("Hello world")
// or
label.attributedText = NSAttributedString(string: "Hello world", style: .title)
// or
label.attributedText = TextStyle
    .title
    .withColor(.white)
    .withLineBreakMode(.byWordWrapping)
    .attributedString("Hello world")
```

The template could be configured using additional options that specified in `templateOptions` parameter:

Key  | Type | Default value | Description
---- | -----| ------------- | -----------
`styleTypeName` | string | TextStyle | Style type name
`colorTypeName` | string | UICOlor | Color type name. If the target platform is macOS, specify `NSColor`.
`fontTypeName` | string | UIFont | Font type name. If the target platform is macOS, specify `NSFont`.
`publicAccess` | flag | false | Flag that adds `public` access modifier to the declarations in the generated file.

## Images
To load and generate code for images, the [standard configuration set](#generation-configuration) is used with additional parameters:
- `assets`: a path to Xcode-assets folder in which the images will be saved as Image Set.
The parameter could be omitted if there is no need for assets.
- `resources`: a path to the resources folder in which the image files will be saved.
The parameter can be skipped, if, for example, you only want to save assets.
- `format`: string with images extension. `pdf`, `png`, `svg`, `jpg` are allowed.
The default extension is `pdf`.
- `scales`: array with integer scaling factors from 1 to 3.
The default scaling factor is 1, so the image will have the original size.

Sample configuration:
```yaml
images:
  accessToken: '25961-4ac9fbc9-3bd8-4c43-bbe2-95e477f8a067'
  file: 'https://www.figma.com/file/61xw2FQn61Xr7VVFYwiHHy/Fugen-Demo'
  assets: 'Sources/Assets.xcasset/Images'
  destination: 'Sources/Images.swift'
  templateOptions:
    publicAccess: true
```

#### Figma components
Fugen only uses nodes that are [components]((https://help.figma.com/article/66-components) as images.
So, make sure that the chosen frame in the file URL (see [Figma file](#figma-file))
allows to filter out the components that should not render images in Figma file.

#### Xcode-assets
It's recommended to specify the path to a subfolder inside the Xcode-assets folder in the `assets` parameter,
so all colors are saved in this subfolder. For example  `Sources/Assets.xcasset/Images`.
The whole assets structure be created if it was missing.

**N.B.:** Folder specified in the `assets` parameter will be emptied before saving colors there.
You shouldn't use the same path for different generation steps,
but you can use different subfolders of the assets folder,
for example `Sources/Assets.xcasset/Colors` and `Sources/Assets.xcasset/Images`.

#### Formats
For Xcode projects, it is recommended to use vector PDF format without additional scaling factors,
for that it is enough not to specify the `format` and `scales` parameter.

There is no point to use SVG for Xcode projects, as it only could be used in other platforms (for example in Android).

#### Scaling factors
An image of the corresponding size will be rendered for each scaling factor in the `scales` array,
regardless of the specified format in the `format` parameter.
However, it is not recommended to use additional scaling factors for vector PDF and SVG formats.

When saved in Xcode assets, files of each scaled image will be kept in the same Image Set with Individual Scales option.
If the `scales` parameter is omitted in the configuration, the Image Set will have the Single Scale scaling type.

#### Default template
Sample usage of the generated code:
```swift
imageView.image = Images.menuIcon
```

The template could be configured using additional options specified in `templateOptions` parameter:

Key  | Type | Default value | Description
---- | -----| ------------- | -----------
`imagesEnumName` | string | TextStyle | Name of a generated enum with static image fields
`imageTypeName` | string | UIImage | Image type name. If the target platform is macOS, specify `NSImage`.
`publicAccess` | flag | false | Flag that adds `public` access modifier to the declarations in the generated file.

---

## Communication
- If you need help, open an issue.
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.

## License
Fugen is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
