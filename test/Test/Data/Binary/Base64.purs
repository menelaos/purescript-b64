module Test.Data.Binary.Base64
  ( testBase64 )
where

import Data.Either        ( fromRight, isLeft )
import Data.Binary.Base64 ( decode, encode, encodeUrl )
import Data.TextDecoder   ( decodeUtf8 )
import Data.TextEncoder   ( encodeUtf8 )
import Effect             ( Effect )
import Effect.Console     ( log )
import Partial.Unsafe     ( unsafePartial )
import Prelude
import Test.Input         ( WellFormedInput (..) )
import Test.StrongCheck   ( Result, (===), assert, quickCheck )

testBase64 :: Effect Unit
testBase64 = do
  log "decode"
  assert $ unsafePartial (fromRight (decode "" >>= decodeUtf8))     === ""
  assert $ unsafePartial (fromRight (decode "YQ==" >>= decodeUtf8)) === "a"
  assert $ unsafePartial (fromRight (decode "YQ=" >>= decodeUtf8))  === "a"
  assert $ unsafePartial (fromRight (decode "YQ" >>= decodeUtf8))   === "a"
  assert $ unsafePartial (fromRight (decode "5p+/44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a+6" >>= decodeUtf8)) === "柿くへば鐘が鳴るなり法隆寺"
  assert $ unsafePartial (fromRight (decode "5p-_44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a-6" >>= decodeUtf8)) === "柿くへば鐘が鳴るなり法隆寺"
  assert $ isLeft (decode "∀")

  log "encode"
  log "Tests will be implemented once `Uint8Array` is in instance of `Eq`"

  log "encodeUrl"
  log "Tests will be implemented once `Uint8Array` is in instance of `Eq`"

  log "decode <<< encode == id for well-formed input"
  let
    encodeDecodeIdProp :: WellFormedInput -> Result
    encodeDecodeIdProp (WellFormedInput str) =
      str ===
        unsafePartial
          (fromRight <<< (decode >=> decodeUtf8) <<< encode $ encodeUtf8 str)

  quickCheck encodeDecodeIdProp

  log "decode <<< encodeUrl == id for well-formed input"
  let
    encodeUrlDecodeIdProp :: WellFormedInput -> Result
    encodeUrlDecodeIdProp (WellFormedInput s) =
      s ===
        unsafePartial
          (fromRight <<< (decode >=> decodeUtf8) <<< encodeUrl $ encodeUtf8 s)

  quickCheck encodeUrlDecodeIdProp
