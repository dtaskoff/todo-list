{-# LANGUAGE DeriveGeneric #-}
module TaskPOST where

import GHC.Generics
import Task (Task(Task), Status(..))
import Yesod.Core.Json

import qualified Task as T
-- ^ because Task exports title, description and status

-- | We're making this as a separate datatype for POST requests, because we want to make sure
-- that using `Task` will enforce setting all fields
data TaskPOST = TaskPOST
  { title       :: String
  , description :: String
  , status      :: Maybe Status
  } deriving Generic

instance FromJSON TaskPOST

createTaskFromPOST :: Int -> TaskPOST -> Task
createTaskFromPOST i taskPOST = Task
  { T.tid = i
  , T.title = title taskPOST
  , T.description = description taskPOST
  , T.status = maybe TODO id (status taskPOST)
  }
