import { useWeb3React } from '@web3-react/core';
import { useEffect, useState } from 'react';
import { isSignerAnAdmin } from '../services/poolsService';
import { usePool } from './usePool';

export const useIsAdmin = (): boolean => {
  const [isAdmin, setIsAdmin] = useState(false);
  const { pool } = usePool();

  const { provider, isActive, chainId, account } = useWeb3React();

  const connected = isActive && pool?.chain_id === chainId;

  useEffect(() => {
    if (pool && connected && account) isSignerAnAdmin(pool, account).then(setIsAdmin);
    else setIsAdmin(false);
  }, [provider, pool, connected, account]);

  return isAdmin;
};
