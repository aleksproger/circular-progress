workspace(name = "circular-progress")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_swift",
    sha256 = "28a66ff5d97500f0304f4e8945d936fe0584e0d5b7a6f83258298007a93190ba",
    url = "https://github.com/bazelbuild/rules_swift/releases/download/1.13.0/rules_swift.1.13.0.tar.gz",
)

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()