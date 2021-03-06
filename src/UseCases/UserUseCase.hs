module UseCases.UserUseCase where

import Control.Lens
import Data.Proxy
import Domain.Types (Id, User, UserResource, WithId (..))
import qualified Domain.UserDomain as Dom
import Polysemy
import Polysemy.Error
import Polysemy.Trace
import UseCases.IdGen
import UseCases.KVS (KVS, deleteKvs, getKvs, insertKvs, listAllKvs)

type Persistence = KVS (Id User) UserResource

-- | The type of error for this use case... try adding more constructors?
newtype UserError = UserNotFound String deriving (Show, Eq)

listUsers :: (Member Persistence r, Member (Error UserError) r, Member Trace r) => Sem r [String]
listUsers = do
    users <- map snd <$> listAllKvs
    trace "Trying to stringify users"
    if not (null users)
        then return $ map Dom.formatUser users
        else throw $ UserNotFound "No user in the DB"

listAll :: (Member Persistence r) => Sem r [UserResource]
listAll = map snd <$> listAllKvs

-- TODO:
--  * generate new id for user
addUser :: (Member Persistence r, Member IdGen r) => User -> Sem r ()
addUser user = do
    userId <- newID (Proxy @User)
    insertKvs userId (WithId userId user)

getUser :: (Member Persistence r, Member (Error UserError) r) => Id User -> Sem r UserResource
getUser userId = do
    user <- getKvs userId
    case user of
        Just u -> pure u
        Nothing -> throw $ UserNotFound ("User with id " ++ show userId ++ " not found")

updateUser :: (Member Persistence r, Member (Error UserError) r) => Id User -> User -> Sem r ()
updateUser k user = do
    _ <- getUser k
    insertKvs k (WithId k user)

deleteUser :: (Member Persistence r) => Id User -> Sem r ()
deleteUser = deleteKvs
