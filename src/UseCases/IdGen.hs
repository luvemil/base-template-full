{-# LANGUAGE TemplateHaskell #-}

module UseCases.IdGen where

import Data.Proxy (Proxy)
import Data.Text (Text)
import Domain.Types
import Polysemy

-- | a key value store specified as A GADT type
data IdGen r a where
    NewID :: Proxy k -> IdGen r (Id k)
    NewSlug :: Bool -> IdGen r Text

makeSem ''IdGen