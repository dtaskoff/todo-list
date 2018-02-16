{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
module Status where

import Database.Persist.TH
import Data.Text (toLower)
import GHC.Generics
import Yesod.Core.Json


data Status = TODO | Done
  deriving (Generic, Read, Show)
derivePersistField "Status"

-- | A custom FromJSON instance, which is not case-sensitive
instance FromJSON Status where
  parseJSON (String s) = case toLower s of
    "todo" -> pure TODO
    "done" -> pure Done
    _      -> fail "status"
  parseJSON _ = fail "status"

instance ToJSON Status
