-- Source: https://github.com/Holmusk/three-layer/blob/master/src/Lib/Core/Id.hs

module Domain.Types.Id (
    Id (..),
    AnyId,
) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)
import qualified Web.Internal.HttpApiData as Web

newtype Id a = Id {unId :: Text}
    deriving stock (Show, Generic)
    deriving newtype (Eq, Ord, Read, FromJSON, ToJSON, Web.FromHttpApiData)

type AnyId = Id ()

data WithId a = WithId
    { _id :: Id a
    , content :: a
    }
    deriving (Eq, Show, Generic, Read)
