module Test.Data.Binary.Base64
  ( testBase64 )
where

import Prelude

import Data.Binary.Base64 (decode, encode, encodeUrl)
import Data.Either (Either(..), isLeft)
import Data.TextDecoder (decodeUtf8)
import Data.TextEncoder (encodeUtf8)
import Effect (Effect)
import Effect.Console (log)
import Effect.Exception.Unsafe (unsafeThrow)
import Test.Assert (assert)
import Test.Input (WellFormedInput(..))
import Test.QuickCheck (Result, (===), quickCheck)

testBase64 :: Effect Unit
testBase64 = do
  log "decode"
  assert $ getRight (decode "" >>= decodeUtf8)    == ""
  assert $ getRight (decode "YQ==" >>= decodeUtf8) == "a"
  assert $ getRight (decode "YQ=" >>= decodeUtf8)  == "a"
  assert $ getRight (decode "YQ" >>= decodeUtf8)   == "a"
  assert $ getRight (decode "5p+/44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a+6" >>= decodeUtf8) == "柿くへば鐘が鳴るなり法隆寺"
  assert $ getRight (decode "5p-_44GP44G444Gw6ZCY44GM6bO044KL44Gq44KK5rOV6ZqG5a-6" >>= decodeUtf8) == "柿くへば鐘が鳴るなり法隆寺"
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
        getRight ((decode >=> decodeUtf8) <<< encode $ encodeUtf8 str)

  quickCheck encodeDecodeIdProp

  log "decode <<< encodeUrl == id for well-formed input"
  let
    encodeUrlDecodeIdProp :: WellFormedInput -> Result
    encodeUrlDecodeIdProp (WellFormedInput s) =
      s ===
          getRight ((decode >=> decodeUtf8) <<< encodeUrl $ encodeUtf8 s)

  quickCheck encodeUrlDecodeIdProp

  where
  getRight (Right r) = r
  getRight (Left _) = unsafeThrow "expected right"