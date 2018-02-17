{-# LANGUAGE DeriveGeneric #-}
module TaskPOST where

import GHC.Generics
import Status
import Task
import Yesod.Core.Json


-- | We're making this as a separate datatype for POST requests, because we want to make sure
-- that using `Task` will enforce setting all fields
data TaskPOST = TaskPOST
  { title       :: String
  , description :: String
  , status      :: Maybe Status
  } deriving Generic

instance FromJSON TaskPOST

taskPOSTToTask :: TaskPOST -> Task
taskPOSTToTask taskPOST = Task
  { taskTitle = title taskPOST
  , taskDescription = description taskPOST
  , taskStatus = maybe TODO id (status taskPOST)
  }
