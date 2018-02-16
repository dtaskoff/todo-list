{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Task where

import Database.Persist.TH
import Status
import Yesod.Persist


-- | Define a Task datatype and a schema for our database
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
      [persistLowerCase|
Task json
  tid         Int
  title       String
  description String
  status      Status
|]


entityTaskToTask :: Entity Task -> Task
entityTaskToTask (Entity key task) = task

matchesID :: Int -> Task -> Bool
matchesID i = (== i) . taskTid

type Tasks = [Task]

addTask :: Task -> Tasks -> Tasks
addTask = (:)

-- | Given an index `i` and Tasks gives a tuple with all Tasks without the first
-- one having such an index and Just that Task, if such Task exists, else Nothing
removeTask :: Int -> Tasks -> (Tasks, Maybe Task)
removeTask i tasks =
  case break (matchesID i) tasks of   -- ^ breaks the list of tasks into two halves
    (ts, t:ts') -> (ts ++ ts', Just t) -- ^ where `t` is the first Task in the list that has an index `i`
    (ts, []) -> (ts, Nothing)
