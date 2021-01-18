{-# LANGUAGE TemplateHaskell #-}

module UseCases.IdGen where

import Domain.Types
import Polysemy

-- | a key value store specified as A GADT type
data IdGen k r a where
    NewID :: IdGen k r (Id k)

makeSem ''IdGen