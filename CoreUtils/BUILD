load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "CoreUtils",
    srcs = glob([
        "**/*.swift",
    ]),
    module_name = "CoreUtils",
    visibility = ["//visibility:public"],
    deps = [
        "//Thirdparty/RxSwift",
    ],
)
