{-# LANGUAGE DeriveGeneric #-}
module TaskPUT where

import Database.Persist
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

-- | Update only these fields, which are not Nothing in taskPUT
taskPUTToUpdates :: TaskPUT -> [Update Task]
taskPUTToUpdates taskPUT =
  maybe [] (\t -> [TaskTitle =. t]) (title taskPUT) ++
  maybe [] (\d -> [TaskDescription =. d]) (description taskPUT) ++
  maybe [] (\s -> [TaskStatus =. s]) (status taskPUT)
