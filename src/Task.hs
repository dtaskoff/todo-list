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
  TaskID     tid
|]


entityTaskToTask :: Entity Task -> Task
entityTaskToTask (Entity key task) = task

type Tasks = [Task]
