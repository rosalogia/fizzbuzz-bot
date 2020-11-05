{-# LANGUAGE DeriveGeneric #-}
module Types (
    Config (..)
) where
import Data.Text
import GHC.Generics
import Data.Aeson

data Config = Config {
    token :: String
} deriving (Generic, Show)

instance ToJSON Config where
    toEncoding = genericToEncoding defaultOptions

instance FromJSON Config

someFunc :: IO ()
someFunc = putStrLn "someFunc"
