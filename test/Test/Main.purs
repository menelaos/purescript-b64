module Test.Main where

import Prelude
import Test.Data.Binary.Base64 as Binary
import Test.Data.String.Base64 as String

main = do
  Binary.testBase64
  String.testBase64
