module Test.Data.String.Base64
  ( testBase64 )
where

import Control.Monad.Eff.Console ( log )
import Data.Either               ( fromRight, isLeft )
import Data.String.Base64        ( decode, encode, encodeUrl )
import Data.String.Utils         ( stripChars )
import Partial.Unsafe            ( unsafePartial )
import Prelude
import Test.Input                ( WellFormedInput (..) )
import Test.StrongCheck          ( Result, SC, (===), assert, quickCheck )

testBase64 :: SC () Unit
testBase64 = do
  log "atob"
  log "`atob` is not available on Node.js"

  log "btoa"
  log "`btoa` is not available on Node.js"

  log "decode"
  assert $ unsafePartial (fromRight (decode ""))     === ""
  assert $ unsafePartial (fromRight (decode "YQ==")) === "a"
  assert $ unsafePartial (fromRight (decode "YQ="))  === "a"
  assert $ unsafePartial (fromRight (decode "YQ"))   === "a"
  assert $ unsafePartial (fromRight (decode "5p+/44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a+6")) === "柿くへば鐘が鳴るなり法隆寺"
  assert $ unsafePartial (fromRight (decode "5p-_44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a-6")) === "柿くへば鐘が鳴るなり法隆寺"
  assert $ isLeft (decode "∀")

  log "encode"
  let
    rfc4648Alphabet :: String
    rfc4648Alphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="

    encodeAlphabetProp :: String -> Result
    encodeAlphabetProp str = stripChars rfc4648Alphabet (encode str) === ""

  assert $ encode ""  === ""
  assert $ encode "a" === "YQ=="
  assert $ encode "柿くへば鐘が鳴るなり法隆寺" ===
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

  assert $ encodeUrl ""  === ""
  assert $ encodeUrl "a" === "YQ"
  assert $ encodeUrl "柿くへば鐘が鳴るなり法隆寺" ===
    "5p-_44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a-6"
  quickCheck encodeUrlAlphabetProp

  log "decode <<< encode == id for well-formed input"
  let
    encodeDecodeIdProp :: WellFormedInput -> Result
    encodeDecodeIdProp (WellFormedInput str) =
      str === unsafePartial (fromRight <<< decode <<< encode $ str)

  quickCheck encodeDecodeIdProp

  log "decode <<< encodeUrl == id for well-formed input"
  let
    encodeUrlDecodeIdProp :: WellFormedInput -> Result
    encodeUrlDecodeIdProp (WellFormedInput str) =
      str === unsafePartial (fromRight <<< decode <<< encodeUrl $ str)

  quickCheck encodeUrlDecodeIdProp
