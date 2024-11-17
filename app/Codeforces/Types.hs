{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Codeforces.Types where

import Data.Aeson (FromJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

data Contest = Contest
  { id :: Integer,
    name :: Text
  }
  deriving (Show, Generic, FromJSON)

data User = User
  { handle :: Text,
    email :: Maybe Text,
    country :: Maybe Text,
    rating :: Maybe Int,
    maxRating :: Maybe Int,
    rank :: Maybe Text,
    maxRank :: Maybe Text,
    contribution :: Maybe Int,
    friendOfCount :: Maybe Int
  }
  deriving (Show, Generic, FromJSON)
