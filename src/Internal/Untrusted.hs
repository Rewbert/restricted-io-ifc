module Internal.Untrusted (
    Untrusted
    , taint
    , trust
) where

-- | A value that is untrusted, indicating that it came from an untrusted source
data Untrusted a = Untrusted a

taint :: a -> Untrusted a
taint a = Untrusted a

-- | Endorse an untrusted value
trust :: Untrusted a -> a
trust (Untrusted a) = a
