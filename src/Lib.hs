module Lib where
import Http (Launch, latestLaunch)
import Servant.Client.Internal.HttpClient (runClientM, mkClientEnv)
import Servant.Client.Core (ClientError, parseBaseUrl)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Network.HTTP.Client (Manager, newManager)
import Servant.Client ( BaseUrl, ClientEnv )

program :: IO ()
program = clientenv >>= program' >>= print

program' :: ClientEnv -> IO String
program' e = render <$> runClientM latestLaunch e

render :: Either ClientError Launch -> String
render = show

url :: Maybe BaseUrl
url = parseBaseUrl "https://api.spacexdata.com"

manager :: IO Manager
manager = newManager tlsManagerSettings

maybeToIO :: Maybe x -> IO x
maybeToIO (Just x) = pure x
maybeToIO Nothing = error "Invalid Url"

clientenv :: IO ClientEnv
-- clientenv = (<*>) (fmap mkClientEnv manager) url
clientenv = mkClientEnv <$> manager <*> maybeToIO url
--clientenv = do 
--    u <- url
--    m <- manager
--    return $ mkClientEnv m u
--clientenv = fmap (mkClientEnv manager) url

runLaunches :: IO (Either ClientError Launch)
runLaunches = clientenv >>= runClientM latestLaunch

-- https://api.spacexdata.com/v4/launches/latest
-- https://api.spacexdata.com/v4/rockets/{rocket_id}
