cmake_minimum_required(VERSION 3.22)

set(CMAKE_Swift_LANGUAGE_VERSION 5.3)

project(cmake-swift-objcpp-metal LANGUAGES Swift OBJCXX CXX)

    add_executable(cmake-swift-objcpp-metal MACOSX_BUNDLE
        AppDelegate.swift
        ContentView.swift
        Main.swift
        Renderer.h
        Renderer.mm
        RendererWrapper.h
        RendererWrapper.mm
        shaders.metal
    )

    set_source_files_properties(shaders.metal PROPERTIES LANGUAGE METAL)
    target_compile_features(cmake-swift-objcpp-metal PRIVATE cxx_std_17)

    # TODO somehow remove generating info.plist by CMake as generating+filling values seems to be saferś
    # TODO SWIFT_OPTIMIZATION_LEVEL "-Onone" For gui preview
    set_target_properties(cmake-swift-objcpp-metal
        PROPERTIES
            XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
            XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_WEAK YES
            XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER RendererWrapper.h
            XCODE_ATTRIBUTE_ENABLE_PREVIEWS YES # also set optimization level to -Onone
            XCODE_ATTRIBUTE_INFOPLIST_FILE ""
            XCODE_ATTRIBUTE_GENERATE_INFOPLIST_FILE YES
            XCODE_ATTRIBUTE_INFOPLIST_KEY_UILaunchScreen_Generation YES
            XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION "alpha"
            XCODE_ATTRIBUTE_MARKETING_VERSION "alpha"
            XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "CMakeSwiftObjcppMetal.Sample"
            XCODE_ATTRIBUTE_CODE_SIGN_STYLE Automatic
    )