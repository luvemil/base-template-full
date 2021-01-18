{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

module Domain.Types.User where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import Domain.Types.Id (Id)
import GHC.Generics (Generic)

data User = User
    { name :: !Text
    , id :: !(Id User)
    }
    deriving stock (Show, Read, Eq, Generic)

instance FromJSON User
instance ToJSON User