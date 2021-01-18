module InterfaceAdapters.Config where

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
  }

data Backend = SQLite | FileServer | InMemory deriving (Show)
