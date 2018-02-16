{-# LANGUAGE DeriveGeneric #-}
module TaskPUT where

import GHC.Generics
import Status
import Task
import Yesod.Core.Json


-- | We're making this as a separate datatype for PUT requests, because we want to make sure
-- that using `Task` will enforce setting all fields
data TaskPUT = TaskPUT
  { title       :: Maybe String
  , description :: Maybe String
  , status      :: Maybe Status
  } deriving Generic

instance FromJSON TaskPUT

-- | Change only these fields, which are not Nothing in taskPUT
updateTask :: Task -> TaskPUT -> Task
updateTask task taskPUT = task
  { taskTitle = maybe (taskTitle task) id (title taskPUT)
  , taskDescription = maybe (taskDescription task) id (description taskPUT)
  , taskStatus = maybe TODO id (status taskPUT)
  }
