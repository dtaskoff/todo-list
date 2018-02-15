{-# LANGUAGE DeriveGeneric #-}
module Types where

import GHC.Generics
import Yesod.Core


{- The DeriveGeneric pragma, and "deriving Generic" below
 - are needed to avoid implementing the FromJSON and ToJSON
 - instances ourselves
 -}
data Task = Task
  { tid         :: Int
  , title       :: String
  , description :: String
  , status      :: Status
  } deriving (Generic, Show)

data Status = TODO | Done
  deriving (Generic, Show)

instance FromJSON Task
instance ToJSON Task

instance FromJSON Status
instance ToJSON Status
