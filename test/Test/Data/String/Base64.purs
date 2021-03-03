module Test.Data.String.Base64
  ( testBase64 )
where

import Prelude

import Data.Either (Either(..), isLeft)
import Data.String.Base64 (decode, encode, encodeUrl)
import Data.String.Utils (stripChars)
import Effect (Effect)
import Effect.Console (log)
import Effect.Exception.Unsafe (unsafeThrow)
import Test.Assert (assert)
import Test.Input (WellFormedInput(..))
import Test.QuickCheck (Result, (===), quickCheck)


testBase64 :: Effect Unit
testBase64 = do
  log "atob"
  log "`atob` is not available on Node.js"

  log "btoa"
  log "`btoa` is not available on Node.js"

  log "decode"
  assert $ getRight (decode "")     == ""
  assert $ getRight (decode "YQ==") == "a"
  assert $ getRight (decode "YQ=")  == "a"
  assert $ getRight (decode "YQ")   == "a"
  assert $ getRight (decode "5p+/44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a+6") == "柿くへば鐘が鳴るなり法隆寺"
  assert $ getRight (decode "5p-_44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a-6") == "柿くへば鐘が鳴るなり法隆寺"
  assert $ isLeft (decode "∀")

  log "encode"
  let
    rfc4648Alphabet :: String
    rfc4648Alphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="

    encodeAlphabetProp :: String -> Result
    encodeAlphabetProp str = stripChars rfc4648Alphabet (encode str) === ""

  assert $ encode ""  == ""
  assert $ encode "a" == "YQ=="
  assert $ encode "柿くへば鐘が鳴るなり法隆寺" ==
    "5p+/44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a+6"
  quickCheck encodeAlphabetProp

  log "encodeUrl"
  let
    urlSafeAlphabet :: String
    urlSafeAlphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

    encodeUrlAlphabetProp :: String -> Result
    encodeUrlAlphabetProp str =
      stripChars urlSafeAlphabet (encodeUrl str) === ""

  assert $ encodeUrl ""  == ""
  assert $ encodeUrl "a" == "YQ"
  assert $ encodeUrl "柿くへば鐘が鳴るなり法隆寺" ==
    "5p-_44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a-6"
  quickCheck encodeUrlAlphabetProp

  log "decode <<< encode == id for well-formed input"
  let
    encodeDecodeIdProp :: WellFormedInput -> Result
    encodeDecodeIdProp (WellFormedInput str) =
      str === getRight (decode <<< encode $ str)

  quickCheck encodeDecodeIdProp

  log "decode <<< encodeUrl == id for well-formed input"
  let
    encodeUrlDecodeIdProp :: WellFormedInput -> Result
    encodeUrlDecodeIdProp (WellFormedInput str) =
      str === getRight (decode <<< encodeUrl $ str)

  quickCheck encodeUrlDecodeIdProp

  where
  getRight (Right r) = r
  getRight (Left _) = unsafeThrow "expected Right"