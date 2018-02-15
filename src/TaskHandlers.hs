module TaskHandlers where

import Control.Concurrent.MVar
import Data.List (find)
import Foundation
import Task
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

getTaskIDR :: Int -> Handler Value
getTaskIDR id' = do
  tasks' <- getTasksYesod
  let mtask = find ((== id') . tid) tasks'
  maybe notFound returnJson mtask

--  let tasks'' = find ((= id') . tid) tasks'
--  let findTask = find ((== id') . tid)
--  let findTask tasks' = find ((== id') . tid) tasks'
--  let findTask = \tasks' -> find ((== id') . tid) tasks'
--  case findTask tasks' of

deleteTaskIDR :: Int -> Handler Value
deleteTaskIDR id' = do
  tasks' <- getsYesod tasks
  mtask <- liftIO $ modifyMVar tasks' (pure . removeTask id')
  maybe notFound returnJson mtask

postTaskR :: Handler Value
postTaskR = do
  task <- requireJsonBody
  let taskStatus = maybe TODO id (statusPOST task)
      task' = undefined

  tasks' <- getsYesod tasks
  tasks'' <- liftIO $ modifyMVar_ tasks' (pure . addTask task')
  returnJson tasks''
