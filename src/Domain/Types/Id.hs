-- Source: https://github.com/Holmusk/three-layer/blob/master/src/Lib/Core/Id.hs

module Domain.Types.Id (
    Id (..),
    AnyId,
) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

newtype Id a = Id {unId :: Text}
    deriving stock (Show, Generic)
    deriving newtype (Eq, Ord, Read, FromJSON, ToJSON)

type AnyId = Id ()