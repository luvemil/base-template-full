module UseCases.FakerUseCase where

import Data.Function ((&))
import qualified Data.Text as T
import Faker
import Faker.Marketing (buzzwords)
import Polysemy

getRandomWords :: Member (Embed IO) r => Sem r T.Text
getRandomWords = do
    let fakerSettings = setNonDeterministic defaultFakerSettings
    buzz <- embed $ generateWithSettings fakerSettings buzzwords
    pure $
        buzz & T.toTitle
            & T.splitOn " "
            & T.concat

getRandomWordsConfig :: Member (Embed IO) r => Maybe T.Text -> Sem r T.Text
getRandomWordsConfig fakerLocales = do
    let fakerSettings = case fakerLocales of
            Just prefix ->
                setNonDeterministic
                    . setLocaleDir prefix
                    $ defaultFakerSettings
            Nothing ->
                setNonDeterministic defaultFakerSettings
    buzz <- embed $ generateWithSettings fakerSettings buzzwords
    pure $
        buzz & T.toTitle
            & T.splitOn " "
            & T.concat
