{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE TypeOperators #-}
module Http where

-- import GHC.TypeLits
import Servant.API (Get, JSON, type (:>))
import GHC.Generics (Generic)
import Data.Aeson (FromJSON)
import Servant.Client (ClientM, client)
import Data.Typeable (Proxy (Proxy))

type Api = "v4" :> "launches" :> "latest" :> Get '[JSON] Launch

newtype LaunchId = LaunchId String deriving (Show, Eq) deriving (FromJSON) via String
newtype RocketId = RocketId String deriving (Show, Eq) deriving (FromJSON) via String
newtype Details = Details String deriving (Show, Eq) deriving (FromJSON) via String
data Launch = Launch {
  id :: LaunchId,
  details :: Details,
  rocket :: RocketId
} deriving (Show, Eq, Generic)
-- details :: Launch -> Details
-- details (Launch _ d) = d

instance FromJSON Launch

latestLaunch :: ClientM Launch
latestLaunch  = client api

api :: Proxy Api
api = Proxy
