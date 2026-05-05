module Test.Data.String.Base64
  ( testBase64 )
where

import Data.Either                 ( isLeft )
import Data.String.Base64          ( atob, btoa, decode, encode, encodeUrl )
import Data.String.Base64.Internal ( unsafeFromRight )
import Data.String.Utils           ( stripChars )
import Effect                      ( Effect )
import Effect.Console              ( log )
import Prelude
import Test.Assert                 ( assert )
import Test.Input                  ( WellFormedInput (..) )
import Test.QuickCheck             ( Result, (===), quickCheck )


testBase64 :: Effect Unit
testBase64 = do
  log "atob"
  assert $ unsafeFromRight (atob "")     == ""
  assert $ unsafeFromRight (atob "YQ==") == "a"
  assert $ unsafeFromRight (atob "YQ")   == "a" -- "YQ" and "YR" both return "a". See step 9 of
  assert $ unsafeFromRight (atob "YR")   == "a" -- https://infra.spec.whatwg.org/#forgiving-base64-decode

  -- Invalid input (see https://infra.spec.whatwg.org/#forgiving-base64-decode)
  assert $ isLeft (decode "∀")   -- Character not in Base64 alphabet
  assert $ isLeft (decode "YQ=") -- Invalid padding

  log "btoa"
  assert $ unsafeFromRight (btoa "")  == ""
  assert $ unsafeFromRight (btoa "a") == "YQ=="
  assert $ isLeft (btoa "∀") -- Code point outside of 0 .. U+00FF

  log "decode"
  assert $ unsafeFromRight (decode "")     == ""
  assert $ unsafeFromRight (decode "YQ==") == "a"
  assert $ unsafeFromRight (decode "YQ")   == "a"
  assert $ unsafeFromRight (decode "5p+/44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a+6") == "柿くへば鐘が鳴るなり法隆寺"
  assert $ unsafeFromRight (decode "5p-_44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a-6") == "柿くへば鐘が鳴るなり法隆寺"

  -- Invalid input (see https://infra.spec.whatwg.org/#forgiving-base64-decode)
  assert $ isLeft (decode "∀")   -- Character not in Base64 alphabet
  assert $ isLeft (decode "YQ=") -- Invalid padding

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
      str === (unsafeFromRight <<< decode <<< encode) str

  quickCheck encodeDecodeIdProp

  log "decode <<< encodeUrl == id for well-formed input"
  let
    encodeUrlDecodeIdProp :: WellFormedInput -> Result
    encodeUrlDecodeIdProp (WellFormedInput str) =
      str === (unsafeFromRight <<< decode <<< encodeUrl) str

  quickCheck encodeUrlDecodeIdProp
