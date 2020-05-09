{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "b64"
, license =
    "Apache-2.0"
, repository =
    "git://github.com/menelaos/purescript-b64.git"
, dependencies =
    [ "arraybuffer-types"
    , "assert"
    , "console"
    , "effect"
    , "either"
    , "encoding"
    , "enums"
    , "exceptions"
    , "functions"
    , "partial"
    , "prelude"
    , "psci-support"
    , "quickcheck"
    , "strings"
    , "stringutils"
    , "unicode"
    , "unsafe-coerce"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
