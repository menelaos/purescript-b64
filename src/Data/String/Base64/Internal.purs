module Data.String.Base64.Internal
  ( atobIsDefined
  , btoaIsDefined
  , uint8ArrayToBtoaSafeString
  , unsafeStringToUint8ArrayOfCharCodes
  , toUrlSafe
  , toRfc4648
  )
where

import Data.ArrayBuffer.Types ( Uint8Array )
import Data.Char.Utils        ( toCodePoint )
import Data.String.Utils      ( replaceAll, toCharArray )
import Data.TypedArray        ( asUint8Array )
import Prelude


foreign import btoaIsDefined :: Boolean
foreign import uint8ArrayToBtoaSafeString :: Uint8Array -> String
foreign import atobIsDefined :: Boolean


-- Helper function to convert (a very specific set of) strings to a `Uint8Array`
-- of Unicode code points.
-- This function is only meant to be used on output strings of the `atob`
-- function. It will NOT work correctly on strings that contain characters
-- whose Unicode code points are outside the range 0 .. U+00FF.
unsafeStringToUint8ArrayOfCharCodes :: String -> Uint8Array
unsafeStringToUint8ArrayOfCharCodes =
  asUint8Array <<< map toCodePoint <<< toCharArray


-- RFC 4648/URL-safe alphabet conversion
--
-- A commonly used variant of Base64 encodes to URL-safe strings and thus
-- uses a slightly different alphabet:
-- ```
-- RFC 4648: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
-- URL-safe: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
-- ```
--
-- Note that URL-safe encoding also removes any `=` padding.
-- The following functions help to convert between the two alphabets.

toUrlSafe :: String -> String
toUrlSafe = replaceAll "=" "" <<< replaceAll "/" "_" <<< replaceAll "+" "-"

toRfc4648 :: String -> String
toRfc4648 = replaceAll "-" "+" <<< replaceAll "_" "/"
