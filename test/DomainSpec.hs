module DomainSpec where

import qualified Data.Aeson as Aeson
import qualified Data.ByteString.Lazy as LB
import Data.Maybe (isJust)
import qualified Domain.Types as Dom
import Test.Hspec
import Test.QuickCheck

main :: IO ()
main = hspec spec

userJson :: LB.ByteString
userJson = "{\"name\":\"User Name\",\"id\":\"uuid-1\"}"

idlessUserJson :: LB.ByteString
idlessUserJson = "{\"name\":\"User Name\"}"

spec :: Spec
spec =
    describe "Domain Logic" $ do
        it "parses a user" $
            isJust parsed `shouldBe` True
        it "parses a user without id" $
            isJust idlessParsed `shouldBe` True
  where
    parsed :: Maybe Dom.User = Aeson.decode userJson
    idlessParsed :: Maybe Dom.User = Aeson.decode idlessUserJson