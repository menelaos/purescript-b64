{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "b64"
, dependencies =
    [ "arraybuffer-types"
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
    , "strings"
    , "stringutils"
    , "strongcheck"
    , "unicode"
    , "unsafe-coerce"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
