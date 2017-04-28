## KSOSearchBar

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](http://img.shields.io/cocoapods/v/KSOSearchBar.svg)](http://cocoapods.org/?q=KSOSearchBar)
[![Platform](http://img.shields.io/cocoapods/p/KSOSearchBar.svg)]()
[![License](http://img.shields.io/cocoapods/l/KSOSearchBar.svg)](https://github.com/Kosoku/KSOSearchBar/blob/master/license.txt)

*KSOSearchBar* is an alternative implementation of `UISearchBar`. The goal being to avoid the graphical and layout issues present in `UISearchBar`.

![demo](screenshots/demo.gif)

### Installation

You can install *KSOSearchBar* using [cocoapods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or as a framework. When installing as a framework, ensure you also link to [Ditko](https://github.com/Kosoku/Ditko), [Stanley](https://github.com/Kosoku/Stanley), and [KSOFontAwesomeExtensions](https://github.com/Kosoku/KSOFontAwesomeExtensions) as *KSOSearchBar* relies on them.

You must also include the *FontAwesome.ttf* font in your application bundle which can be found at [http://fontawesome.io/](http://fontawesome.io/).

### Dependencies

Third party:

- [Stanley](https://github.com/Kosoku/Stanley)
- [Ditko](https://github.com/Kosoku/Ditko)
- [KSOFontAwesomeExtensions](https://github.com/Kosoku/KSOFontAwesomeExtensions)

Apple:

- `UIKit`, `iOS` and `tvOS`