{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Task where

import Data.Char (toLower)
import GHC.Generics
import Yesod.Core


matchesID :: Int -> Task -> Bool
matchesID i = (== i) . tid

createTaskFromPOST :: TaskPOST -> Int -> Task
createTaskFromPOST taskPOST i = Task
  { tid = i
  , title = titlePOST taskPOST
  , description = descriptionPOST taskPOST
  , status = maybe TODO id (statusPOST taskPOST)
  }

addTask :: Task -> Tasks -> Tasks
addTask = (:)

removeTask :: Int -> Tasks -> (Tasks, Maybe Task)
removeTask id' tasks =
  case break ((== id') . tid) tasks of
    (tasks', []) -> (tasks', Nothing)
    (tasks', t:ts) -> (tasks' ++ ts, Just t)

updateTask :: Task -> TaskPUT -> Task
updateTask task taskPUT = task
  { title = maybe (title task) id (titlePUT taskPUT)
  , description = maybe (description task) id (descriptionPUT taskPUT)
  }

{- The DeriveGeneric pragma, and "deriving Generic" below
 - are needed to avoid implementing the FromJSON and ToJSON
 - instances ourselves
 -}
data Task = Task
  { tid         :: Int
  , title       :: String
  , description :: String
  , status      :: Status
  } deriving (Generic)

data TaskPOST = TaskPOST
  { titlePOST       :: String
  , descriptionPOST :: String
  , statusPOST :: Maybe Status
  } deriving (Generic, Show)

data TaskPUT = TaskPUT
  { titlePUT       :: Maybe String
  , descriptionPUT :: Maybe String
  , statusPUT      :: Maybe Status
  } deriving (Generic, Show)

type Tasks = [Task]

data Status = TODO | InProgress | Done
  deriving (Generic, Read, Show)

instance FromJSON Task
instance ToJSON Task

instance FromJSON TaskPOST
instance ToJSON TaskPOST

instance FromJSON TaskPUT
instance ToJSON TaskPUT

-- | A custom FromJSON instance which is not case-sensitive
instance FromJSON Status where
  parseJSON (Object v) = fmap mkStatus (v .: "status")
    where mkStatus status =
            case map toLower status of
              "todo" -> TODO
              "inprogress" -> InProgress
              "done" -> Done

instance ToJSON Status
