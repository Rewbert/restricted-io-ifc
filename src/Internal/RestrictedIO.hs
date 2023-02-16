{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Internal.RestrictedIO (
    RestrictedIO
    , UnsafeFileIO(..)
    , EntropyIO(..)
) where

import Data.Kind

import Internal.Untrusted

type RestrictedIO m = (UnsafeFileIO m, EntropyIO m)

class UnsafeFileIO (m :: Type -> Type) where
    -- | read a file from an untrusted part of the filesystem, yielding an untrusted
    -- Value
    untrustedReadFile  :: FilePath -> m (Untrusted String)
    -- | write to the untrusted part of the filesystem. This is identical to the
    -- conventional @readFile@ function
    untrustedWriteFile :: FilePath -> String -> m ()

class EntropyIO (m :: Type -> Type) where
    type Entropy m
    type RNG m
    genEntropyPool :: m (Entropy m)
    getRNG :: Entropy m -> m (RNG m)

-- class ReferenceIO (m :: Type -> Type) (c :: Type -> Type) where
--     type Ref m 
--     newRemoteRef :: a -> c (m (Ref a))
