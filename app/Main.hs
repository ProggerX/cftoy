{-# LANGUAGE OverloadedStrings #-}

module Main where

import Codeforces.API qualified as API
import Configuration.Dotenv
import Control.Applicative
import Control.Monad.IO.Class
import Data.Text
import Data.Text qualified as Text
import Human
import System.Environment
import Telegram.Bot.API
import Telegram.Bot.Simple
import Telegram.Bot.Simple.UpdateParser

type Handle = Text

data Model = Model {}

initialModel :: Model
initialModel = Model{}

data Action
  = Start
  | GetInfo Handle
  deriving (Show, Read)

todoBot3 :: BotApp Model Action
todoBot3 =
  BotApp
    { botInitialModel = initialModel
    , botAction = flip updateToAction
    , botHandler = handleAction
    , botJobs = []
    }
 where
  updateToAction :: Model -> Update -> Maybe Action
  updateToAction _ =
    parseUpdate $
      Start <$ command "start"
        <|> GetInfo <$> command "info"
        <|> callbackQueryDataRead

  handleAction :: Action -> Model -> Eff Action Model
  handleAction action model = case action of
    Start ->
      model <# do
        reply
          (toReplyMessage startMessage)
    GetInfo handle ->
      model <# do
        usr <- liftIO $ API.userInfo handle
        let msg = toReplyMessage $ userToReadable usr
        reply $ msg{replyMessageParseMode = Just HTML}
  startMessage =
    Text.unlines
      ["Hello! I am your Codeforces helper bot"]

run :: Token -> IO ()
run token = do
  env <- defaultTelegramClientEnv token
  startBot_ (conversationBot updateChatId todoBot3) env

main :: IO ()
main = do
  loadFile defaultConfig
  token <- Token . Text.pack <$> getEnv "TELEGRAM_BOT_TOKEN"
  run token
