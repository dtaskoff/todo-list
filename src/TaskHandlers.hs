module TaskHandlers where

import Control.Concurrent.MVar
import Database.Persist
import Data.List (find)
import Foundation
import Network.HTTP.Types.Status (internalServerError500)
import Task
import TaskGET
import TaskPOST
import TaskPUT
import Yesod.Core
import Yesod.Core.Handler
import Yesod.Persist


getTaskR :: Handler Value
getTaskR = do
  tasks' <- runDB $ selectList [] []
  returnJson $
    map (\(Entity key task) -> taskToTaskGET key task) tasks'

-- Note: requireJsonBody succeeds only if the passed JSON is correct, e.g. matches the
-- FromJSON instance for Task
postTaskR :: Handler Value
postTaskR = do
  taskPOST <- requireJsonBody
  (key, mtask) <- runDB $ do
    k <- insert $ taskPOSTToTask taskPOST
    mt <- get k
    pure (k, mt)
  maybe (sendResponseStatus internalServerError500 "")
        (returnJson . taskToTaskGET key) mtask

getTaskIDR :: TaskKey -> Handler Value
getTaskIDR key = do
  mtask <- runDB $ get key
  maybe notFound (returnJson . taskToTaskGET key) mtask

deleteTaskIDR :: TaskKey -> Handler Value
deleteTaskIDR key = do
  mtask <- runDB $ do
    res <- get key
    delete key
    pure res
  maybe notFound (returnJson . taskToTaskGET key) mtask

putTaskIDR :: TaskKey -> Handler Value
putTaskIDR key = do
  taskPUT <- requireJsonBody
  mtask <- runDB $ do
    update key $ taskPUTToUpdates taskPUT
    get key

  maybe notFound (returnJson . taskToTaskGET key) mtask
