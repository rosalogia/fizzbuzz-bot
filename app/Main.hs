{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (when)
import Data.Text (tail, head, pack)
import qualified Data.Text.IO as TIO
import Discord
import Discord.Types
import Types (Config, token)
import qualified Discord.Requests as R
import qualified Data.ByteString.Lazy as B
import Data.Aeson (eitherDecode)

prefix = '!'

ttail = Data.Text.tail
thead = Data.Text.head

readConfig :: String -> IO (Either String Config)
readConfig configPath = do
    config <- (eitherDecode <$> configFile) :: IO (Either String Config)
    return config
    where
        configFile = B.readFile configPath
    
commandHandler (MessageCreate m) =
    let command = ttail . messageText $ m in
    case command of
    "test"  ->  do  restCall (R.CreateMessage (messageChannel m) "Success")
                    pure ()
    _       -> do pure ()

eventHandler :: Event -> DiscordHandler ()
eventHandler event = case event of
       MessageCreate m -> when ((== prefix) . thead . messageText $ m) $ do commandHandler event
       _ -> pure ()

main :: IO ()
main = do
    config <- readConfig "config.json"
    let botToken = case config of
                    Left err -> err
                    Right cfg -> token cfg
    userFacingError <- runDiscord $ def
        { discordToken = pack botToken
        , discordOnEvent = eventHandler }
    TIO.putStrLn userFacingError
