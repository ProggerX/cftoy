{-# LANGUAGE OverloadedStrings #-}

module Human where

import Codeforces.Types
import Data.Text qualified as T
import Data.Typeable

userToReadable :: User -> T.Text
userToReadable usr =
  T.unlines $
    map
      T.concat
      [ ["<b>User info</b>"]
      , ["Handle: <i>", handle usr, "</i>"]
      , ["E-mail: <i>", helper $ email usr, "</i>"]
      , ["Country: <i>", helper $ country usr, "</i>"]
      , ["Rank: <i>", helper $ rank usr, "</i>"]
      , ["Max rank: <i>", helper $ maxRank usr, "</i>"]
      , ["Rating: <i>", helper $ rating usr, "</i>"]
      , ["Max rating: <i>", helper $ maxRating usr, "</i>"]
      , ["Contribution: <i>", helper $ contribution usr, "</i>"]
      , ["Friends count: <i>", helper $ friendOfCount usr, "</i>"]
      ]
 where
  helper :: (Show a, Typeable a) => Maybe a -> T.Text
  helper Nothing = "Undefined"
  helper (Just x) = case cast x of
    Just (t :: T.Text) -> t
    Nothing -> T.pack $ show x
