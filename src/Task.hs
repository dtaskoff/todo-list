{-# LANGUAGE DeriveGeneric #-}
module Task where

import GHC.Generics
import Yesod.Core.Json


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

matchesID :: Int -> Task -> Bool
matchesID i = (== i) . tid

type Tasks = [Task]

-- | Change only these fields, which are not Nothing in taskPUT
updateTask :: Task -> TaskPUT -> Task
updateTask task taskPUT = task
  { title = maybe (title task) id (titlePUT taskPUT)
  , description = maybe (description task) id (descriptionPUT taskPUT)
  , status = maybe TODO id (statusPUT taskPUT)
  }

addTask :: Task -> Tasks -> Tasks
addTask = (:)

-- | We're making this as a separate datatype for PUT requests, because we want to make sure
-- that using `Task` will enforce setting all fields
data TaskPUT = TaskPUT
  { titlePUT       :: Maybe String
  , descriptionPUT :: Maybe String
  , statusPUT      :: Maybe Status
  } deriving Generic

-- | Given an index `i` and Tasks gives a tuple with all Tasks without the first
-- one having such an index and Just that Task, if such Task exists, else Nothing
removeTask :: Int -> Tasks -> (Tasks, Maybe Task)
removeTask i tasks =
  case break (matchesID i) tasks of   -- ^ breaks the list of tasks into two halves
    (ts, t:ts') -> (ts ++ ts', Just t) -- ^ where `t` is the first Task in the list that has an index `i`
    (ts, []) -> (ts, Nothing)

data Status = TODO | Done
  deriving (Generic, Show)

instance FromJSON Task
instance ToJSON Task

instance FromJSON TaskPUT
instance ToJSON TaskPUT

instance FromJSON Status
instance ToJSON Status
