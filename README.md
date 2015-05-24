# Dates
Swift framework for a Date class and some other functionality.. since it's S it has to be a framework, no static lib.

Was going to make this a [Cocoapod](https://cocoapods.org/) but decided against it for now because they just added support for Swift frameworks and the advantages of publishing with them don't seem to apply as much for frameworks. Could potentially be disabused of this belief.

## Adding the Framework to a Project
Should be simple:

1. clone this repository
1. find the xcode project in Finder and drag and drop to workspace
1. add your app to depend on the framework

That should do it. You should not have to mess with the header search path.
