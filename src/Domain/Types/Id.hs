-- Source: https://github.com/Holmusk/three-layer/blob/master/src/Lib/Core/Id.hs

module Domain.Types.Id (
    Id (..),
    AnyId,
    WithId (..),
) where

import Data.Aeson (FromJSON, ToJSON, (.:))
import qualified Data.Aeson as Aeson
import Data.HashMap.Strict (insert)
import Data.Text (Text)
import GHC.Generics (Generic)
import qualified Web.Internal.HttpApiData as Web

newtype Id a = Id {unId :: Text}
    deriving stock (Show, Generic)
    deriving newtype (Eq, Ord, Read, FromJSON, ToJSON, Web.FromHttpApiData)

type AnyId = Id ()

data WithId a = WithId
    { _id :: !(Id a)
    , content :: !(a)
    }
    deriving (Eq, Show, Generic, Read)

instance ToJSON a => ToJSON (WithId a) where
    toJSON x =
        let val = Aeson.toJSON (content x)
            idVal = Aeson.toJSON (_id x)
         in case val of
                Aeson.Object obj -> Aeson.Object (insert "_id" idVal obj)
                _ -> val

instance FromJSON a => FromJSON (WithId a) where
    parseJSON x = Aeson.withObject "getId" parser x
      where
        parser = \obj -> do
            objId <- obj .: "_id"
            restObj <- Aeson.parseJSON x
            pure $ WithId objId restObj