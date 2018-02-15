{-# LANGUAGE DeriveGeneric #-}
module TaskPUT where

import GHC.Generics
import Task (Task, Status(..))
import Yesod.Core.Json

import qualified Task as T
-- ^ because Task exports title, description and status

-- | We're making this as a separate datatype for PUT requests, because we want to make sure
-- that using `Task` will enforce setting all fields
data TaskPUT = TaskPUT
  { title       :: Maybe String
  , description :: Maybe String
  , status      :: Maybe Status
  } deriving Generic

instance FromJSON TaskPUT
instance ToJSON TaskPUT

-- | Change only these fields, which are not Nothing in taskPUT
updateTask :: Task -> TaskPUT -> Task
updateTask task taskPUT = task
  { T.title = maybe (T.title task) id (title taskPUT)
  , T.description = maybe (T.description task) id (description taskPUT)
  , T.status = maybe TODO id (status taskPUT)
  }
