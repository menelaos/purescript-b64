module Test.Main where

import Effect                  ( Effect )
import Prelude
import Test.Data.Binary.Base64 as Binary
import Test.Data.String.Base64 as String

main :: Effect Unit
main = do
  Binary.testBase64
  String.testBase64
