{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
module Foundation where

import Control.Concurrent.MVar
import Database.Persist.Sqlite
import Task
import Yesod.Core
import Yesod.Persist


data App = App { dbPool :: ConnectionPool }

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend
  runDB action = do
    pool <- getsYesod dbPool
    runSqlPool action pool
