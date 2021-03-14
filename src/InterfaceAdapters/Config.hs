module InterfaceAdapters.Config where

import Data.Text (Text)

-- | global application configuration
data Config = Config
  { -- | the port where the server is listening
    port :: Int
  , -- | selects the persistence backend for the KV store
    backend :: Backend
  , -- | the path to the database
    dbPath :: String
  , -- | True enables logging
    verbose :: Bool
  , -- | Location of faker locales
    fakerLocales :: Maybe Text
  }

data Backend = SQLite | FileServer | InMemory deriving (Show)
