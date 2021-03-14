module InterfaceAdapters.IdGenRandom where

import Data.UUID (toText)
import Data.UUID.V4 (nextRandom)
import Domain.Types.Id
import InterfaceAdapters.Config
import Polysemy
import Polysemy.Input
import UseCases.FakerUseCase
import UseCases.IdGen

runIdGenIO :: (Member (Embed IO) r, Member (Input Config) r) => Sem (IdGen : r) a -> Sem r a
runIdGenIO = interpret $ \case
    NewID _ -> do
        newId <- toText <$> embed nextRandom
        pure $ Id newId
    NewSlug False -> getRandomWordsConfig Nothing
    NewSlug True -> do
        config <- input
        getRandomWordsConfig (fakerLocales config)