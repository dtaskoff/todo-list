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


data App = App { dbPool :: ConnectionPool
               , nextIndex :: MVar Int
               }

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend
  runDB action = do
    pool <- getsYesod dbPool
    runSqlPool action pool

-- | Returns the next index and updates it (increments it by one)
getNextIndex :: Handler Int
getNextIndex = do
  nextIndexMVar <- getsYesod nextIndex
  liftIO $ modifyMVar nextIndexMVar (\i -> pure (i + 1, i))
