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
Task
  title       String
  description String
  status      Status
|]

type TaskKey = Key Task
