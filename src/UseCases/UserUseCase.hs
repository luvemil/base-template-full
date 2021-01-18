module UseCases.UserUseCase where

import Domain.Types (Id, User)
import qualified Domain.UserDomain as Dom
import Polysemy
import Polysemy.Error
import Polysemy.Trace
import UseCases.KVS (KVS, listAllKvs)

type Persistence = KVS (Id User) User

-- | The type of error for this use case... try adding more constructors?
newtype UserError = UserNotFound String deriving (Show, Eq)

listUsers :: (Member Persistence r, Member (Error UserError) r, Member Trace r) => Sem r [String]
listUsers = do
    users <- map snd <$> listAllKvs
    trace "Trying to stringify users"
    if not (null users)
        then return $ map Dom.formatUser users
        else throw $ UserNotFound "No user in the DB"

listAll :: (Member Persistence r) => Sem r [User]
listAll = map snd <$> listAllKvs