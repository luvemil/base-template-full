module InterfaceAdapters.UserRestService where

import qualified Domain.Types as Dom
import qualified Domain.UserDomain as Dom
import Polysemy
import Polysemy.Error
import Polysemy.Trace
import Servant
import UseCases.IdGen (IdGen)
import qualified UseCases.UserUseCase as UC

type UserAPI =
    "users" :> Summary "Returns the list of all the users" :> Get '[JSON] [Dom.UserResource]
        :<|> "users" :> Summary "Returns a list of summaries for the users"
            :> "summary"
            :> Get '[JSON] [String]
        :<|> "users" :> Summary "Add a new user"
            :> ReqBody '[JSON] Dom.User
            :> Post '[JSON] ()
        :<|> "users" :> Summary "Update a user"
            :> Capture "userid" (Dom.Id Dom.User)
            :> ReqBody '[JSON] Dom.User
            :> Post '[JSON] ()
        :<|> "users" :> Summary "Delete a user"
            :> Capture "userid" (Dom.Id Dom.User)
            :> Delete '[JSON] ()
        :<|> "users" :> Summary "Get user by id"
            :> Capture "userid" (Dom.Id Dom.User)
            :> Get '[JSON] Dom.UserResource

-- userServer :: (Member UC.Persistence r, Member (Error UC.UserError) r, Member Trace r) => ServerT UserAPI (Sem r)
userServer :: (Member UC.Persistence r, Member (Error UC.UserError) r, Member Trace r, Member IdGen r) => ServerT UserAPI (Sem r)
userServer = UC.listAll :<|> UC.listUsers :<|> UC.addUser :<|> UC.updateUser :<|> UC.deleteUser :<|> UC.getUser

userAPI :: Proxy UserAPI
userAPI = Proxy