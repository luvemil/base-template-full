module DomainSpec where

import qualified Data.Aeson as Aeson
import qualified Data.ByteString.Lazy as LB
import qualified Domain.Types as Dom
import Test.Hspec
import Test.QuickCheck

main :: IO ()
main = hspec spec

userJson :: LB.ByteString
userJson = "{\"name\":\"User Name\",\"id\":\"uuid-1\"}"

spec :: Spec
spec =
    describe "Domain Logic" $ do
        it "parses a user" $
            canParseUser `shouldBe` True
  where
    canParseUser = case parsed of
        Just _ -> True
        Nothing -> False
    parsed :: Maybe Dom.User = Aeson.decode userJson