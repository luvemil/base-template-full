module ExternalInterfaces.ApplicationAssembly where

import Control.Monad.Except
import Data.Aeson.Types (FromJSON, ToJSON)
import Data.ByteString (ByteString)
import Data.ByteString.Lazy.Char8 (pack)
import Data.Function ((&))
import InterfaceAdapters.Config
import InterfaceAdapters.IdGenRandom (runIdGenIO)
import InterfaceAdapters.KVSFileServer (runKvsAsFileServer)
import InterfaceAdapters.KVSSqlite (runKvsAsSQLite)
import InterfaceAdapters.UserRestService
import Polysemy
import Polysemy.Error
import Polysemy.Input (Input, runInputConst)
import Polysemy.Trace (Trace, ignoreTrace, traceToIO)
import Servant.Server
import Toml (
  TomlCodec,
  (.=),
 )
import qualified Toml
import UseCases.KVS
import UseCases.UserUseCase

{- | creates the WAI Application that can be executed by Warp.run.
 All Polysemy interpretations must be executed here.
-}
createApp :: Config -> Application
createApp config = serve userAPI (liftServer config)

liftServer :: Config -> ServerT UserAPI Handler
liftServer config = hoistServer userAPI (interpretServer config) userServer
 where
  interpretServer conf sem =
    sem
      & selectKvsBackend conf
      & runInputConst conf
      & runIdGenIO
      & runError @UserError
      & selectTraceVerbosity conf
      & runM
      & liftToHandler
  liftToHandler = Handler . ExceptT . fmap handleErrors
  handleErrors (Left (UserNotFound msg)) = Left err412{errBody = pack msg}
  handleErrors (Right value) = Right value

-- | can select between SQLite or FileServer persistence backends.
selectKvsBackend ::
  (Member (Input Config) r, Member (Embed IO) r, Member Trace r, Show k, Read k, ToJSON v, FromJSON v) =>
  Config ->
  Sem (KVS k v : r) a ->
  Sem r a
selectKvsBackend config = case backend config of
  SQLite -> runKvsAsSQLite
  FileServer -> runKvsAsFileServer
  InMemory -> error "not supported"

-- | if the config flag verbose is set to True, trace to Console, else ignore all trace messages
selectTraceVerbosity :: (Member (Embed IO) r) => Config -> (Sem (Trace : r) a -> Sem r a)
selectTraceVerbosity config =
  if verbose config
    then traceToIO
    else ignoreTrace

-- | TOML codec for the 'Config' data type.
configT :: TomlCodec Config
configT =
  Config
    <$> Toml.int "port" .= port
    <*> backendCodec .= backend
    <*> Toml.string "dbPath" .= dbPath
    <*> Toml.bool "verbose" .= verbose

backendCodec :: TomlCodec Backend
backendCodec = Toml.dimap outputBackend chooseBackend (Toml.text "backend")
 where
  outputBackend = \case
    SQLite -> "sqlite"
    FileServer -> "fs"
    InMemory -> "mem"
  chooseBackend = \case
    "sqlite" -> SQLite
    "fs" -> FileServer
    "mem" -> InMemory
    _ -> error "Error"

-- | Loads the @config.toml@ file.
loadConfig :: MonadIO m => m Config
loadConfig = Toml.decodeFile configT "config.toml"

{- | load application config. In real life, this would load a config file or read commandline args.
 loadConfig :: IO Config
 loadConfig = return Config{port = 8080, backend = SQLite, dbPath = "kvs.db", verbose = True}
-}