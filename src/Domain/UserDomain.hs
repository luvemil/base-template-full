module Domain.UserDomain where

import Control.Lens
import Data.Generics.Labels ()
import Data.Generics.Product ()
import Data.Generics.Sum ()
import Domain.Types (UserResource)

-- In format User we use `user ^. #name` to show how to use Control.Lens, but
-- we could have just as easily done `User {..} = user` and simply refer to the
-- name variable
formatUser :: UserResource -> String
formatUser user =
    concat
        [ "User's name: "
        , show (user ^. #content . #name)
        , " (id: "
        , show (user ^. #_id)
        , ")"
        ]
