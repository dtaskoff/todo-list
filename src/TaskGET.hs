{-# LANGUAGE DeriveGeneric #-}
module TaskGET where

import GHC.Generics
import Status
import Task
import Yesod.Core.Json


-- | We're making this as a separate datatype for GET requests, because we want to make sure
-- that using `Task` will enforce setting all fields
data TaskGET = TaskGET
  { tid         :: TaskKey
  , title       :: String
  , description :: String
  , status      :: Status
  } deriving Generic

instance ToJSON TaskGET

taskToTaskGET :: TaskKey -> Task -> TaskGET
taskToTaskGET key task = TaskGET
  { tid = key
  , title = taskTitle task
  , description = taskDescription task
  , status = taskStatus task
  }
