module InterfaceAdapters.IdGenRandom where

import Data.UUID (toText)
import Data.UUID.V4 (nextRandom)
import Domain.Types.Id
import Polysemy
import UseCases.IdGen

runIdGenIO :: Member (Embed IO) r => Sem (IdGen : r) a -> Sem r a
runIdGenIO = interpret $ \case
    NewID _ -> do
        newId <- toText <$> embed nextRandom
        pure $ Id newId