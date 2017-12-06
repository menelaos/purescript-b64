module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Random (RANDOM)
import Test.Data.Binary.Base64 as Binary
import Test.Data.String.Base64 as String

main :: Eff (console :: CONSOLE, random :: RANDOM, exception :: EXCEPTION) Unit
main = do
  Binary.testBase64
  String.testBase64
