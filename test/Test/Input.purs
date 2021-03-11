module Test.Input
  ( WellFormedInput (..) )
where

import Data.Array                ( filter )
import Data.CodePoint.Unicode    ( isPrint )
import Data.String.CodePoints    ( fromCodePointArray, toCodePointArray )
import Prelude
import Test.QuickCheck.Arbitrary ( class Arbitrary, arbitrary )


-- When UTF8-encoding a string, surrogate code points and other non-characters
-- are simply replaced by the replacement character � (U+FFFD).
-- This entails that the `encode` function is not injective anymore and
-- thus the desired property `decode <<< encode == id` does not hold
-- in general.
--
-- For well-formed input strings, however, we can expect the property to hold.

-- Use a newtype in order to define an `Arbitrary` instance.
newtype WellFormedInput = WellFormedInput String

-- The `Arbitrary` instance for `String` currently simply chooses characters
-- out of the first 65536 unicode code points.
-- See the `Arbitrary` instance for `Char` in `purescript-quickcheck`.
instance arbWellFormedInput :: Arbitrary WellFormedInput where
  arbitrary = WellFormedInput
            <<< fromCodePointArray
            <<< filter isPrint
            <<< toCodePointArray
            <$> arbitrary
