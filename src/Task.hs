{-# LANGUAGE DeriveGeneric #-}
module Task where

import GHC.Generics
import Yesod.Core


addTask :: Task -> Tasks -> Tasks
addTask = (:)

removeTask :: Int -> Tasks -> (Tasks, Maybe Task)
removeTask id' tasks =
  case break ((== id') . tid) tasks of
    (tasks', []) -> (tasks', Nothing)
    (tasks', x:xs) -> (tasks' ++ xs, Just x)

{- The DeriveGeneric pragma, and "deriving Generic" below
 - are needed to avoid implementing the FromJSON and ToJSON
 - instances ourselves
 -}
data Task = Task
  { tid    :: Int
  , text   :: TaskText
  , status :: Status
  } deriving (Generic)

data TaskPOST = TaskPOST
  { textPOST   :: TaskText
  , statusPOST :: Maybe Status
  } deriving (Generic, Show)

data TaskText = TaskText
  { title       :: String
  , description :: String
  } deriving (Generic, Show)

type Tasks = [Task]

data Status = TODO | InProgress | Done
  deriving (Generic, Show)

instance FromJSON Task
instance ToJSON Task

instance FromJSON TaskText
instance ToJSON TaskText

instance FromJSON TaskPOST
instance ToJSON TaskPOST

instance FromJSON Status
instance ToJSON Status
