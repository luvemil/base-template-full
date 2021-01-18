module InterfaceAdapters.UserRestService where

import qualified Domain.Types as Dom
import qualified Domain.UserDomain as Dom
import Polysemy
import Polysemy.Error
import Polysemy.Trace
import Servant
import qualified UseCases.UserUseCase as UC

type UserAPI =
    "users" :> Get '[JSON] [Dom.User]
        :<|> "users" :> "summary" :> Get '[JSON] [String]

userServer :: (Member UC.Persistence r, Member (Error UC.UserError) r, Member Trace r) => ServerT UserAPI (Sem r)
userServer = UC.listAll :<|> UC.listUsers

userAPI :: Proxy UserAPI
userAPI = Proxy