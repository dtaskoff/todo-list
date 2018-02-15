module TaskHandlers where

import Control.Concurrent.MVar
import Control.Monad
import Data.List (find)
import Foundation
import Task
import Text.Read (readMaybe)
import Yesod.Core


getTasksYesod :: Handler Tasks
-- getTasksYesod = liftIO . readMVar =<< getsYesod tasks
getTasksYesod = do
  tasksMVar <- getsYesod tasks
  liftIO $ readMVar tasksMVar

getTaskR :: Handler Value
-- getTaskR = returnJson =<< getTasksYesod
getTaskR = do
  tasks' <- getTasksYesod
  returnJson tasks'

postTaskR :: Handler Value
postTaskR = do
  task <- requireJsonBody
  nextIndexMVar <- getsYesod nextIndex
  id' <- liftIO $ modifyMVar nextIndexMVar (\i -> pure (i + 1, i))

  let task' = createTaskFromPOST task id'

  tasks' <- getsYesod tasks
  tasks'' <- liftIO $ modifyMVar_ tasks' (pure . addTask task')
  returnJson tasks''

getTaskIDR :: Int -> Handler Value
getTaskIDR id' = do
  tasks' <- getTasksYesod
  let mtask = find (matchesID id') tasks'
  maybe notFound returnJson mtask

--  let tasks'' = find (matchesID id') tasks'
--  let findTask = find (matchesID id')
--  let findTask tasks' = find (matchesID id') tasks'
--  let findTask = \tasks' -> find (matchesID id') tasks'
--  case findTask tasks' of

deleteTaskIDR :: Int -> Handler Value
deleteTaskIDR id' = do
  tasks' <- getsYesod tasks
  mtask <- liftIO $ modifyMVar tasks' (pure . removeTask id')
  maybe notFound returnJson mtask

putTaskIDR :: Int -> Handler Value
putTaskIDR id' = do
  tasksMVar <- getsYesod tasks
  tasks' <- liftIO $ readMVar tasksMVar

  case find (matchesID id') tasks' of
    Nothing -> notFound
    Just task -> do
      task' <- requireJsonBody
      let task'' = updateTask task task'
      liftIO $ modifyMVar_ tasksMVar $
        pure . addTask task'' . fst . removeTask id'
      returnJson task
