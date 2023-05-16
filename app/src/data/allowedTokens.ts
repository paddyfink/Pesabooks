import { Token } from '@pesabooks/types';

export const allowedTokens: { [key: number]: Token[] } = {
  1: [
    {
      address: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
      symbol: 'USDC',
      name: 'USD Coin',
      image: 'images/token/usdc.png',
      active: true,
      decimals: 6,
      chain_id: 1,
    },
    {
      address: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
      symbol: 'USDT',
      name: 'Tether USD',
      image: 'images/token/usdt.png',
      active: true,
      decimals: 6,
      chain_id: 1,
    },
    {
      address: '0x6B175474E89094C44Da98b954EedeAC495271d0F',
      symbol: 'DAI',
      name: 'Dai Stablecoin',
      image: 'images/token/dai.png',
      active: true,
      decimals: 18,
      chain_id: 1,
    },
    {
      address: '0xcaDC0acd4B445166f12d2C07EAc6E2544FbE2Eef',
      symbol: 'CADC',
      name: 'CAD Coin',
      image: 'images/token/cadc.png',
      active: true,
      decimals: 18,
      chain_id: 1,
    },
    {
      address: '0xdB25f211AB05b1c97D595516F45794528a807ad8',
      symbol: 'EURS',
      name: 'STASIS EURS Token',
      image: 'images/token/eurs.png',
      active: true,
      decimals: 2,
      chain_id: 1,
    },
  ],
  80001: [
    {
      address: '0x001b3b4d0f3714ca98ba10f6042daebf0b1b7b6f',
      symbol: 'DAI',
      name: 'Dai Stablecoin - Aave',
      image: 'images/token/dai.png',
      active: true,
      decimals: 18,
      chain_id: 80001,
    },
    {
      address: '0x9e61d746ad1e0a803ffc5211cfcbc20764dbbbc0',
      symbol: 'PSBK',
      name: 'Pesapool USD',
      image: 'images/token/usdc.png',
      active: false,
      decimals: 6,
      chain_id: 80001,
    },
    {
      address: '0x2058a9d7613eee744279e3856ef0eada5fcbaa7e',
      symbol: 'USDC',
      name: 'USD Coin - Aave',
      image: 'images/token/usdc.png',
      active: true,
      decimals: 6,
      chain_id: 80001,
    },
  ],

  137: [
    {
      address: '0x2791bca1f2de4661ed88a30c99a7a9449aa84174',
      symbol: 'USDC',
      name: 'USD Coin',
      image: 'images/token/usdc.png',
      active: true,
      decimals: 6,
      chain_id: 137,
    },
    {
      address: '0x8f3cf7ad23cd3cadbd9735aff958023239c6a063',
      symbol: 'DAI',
      name: 'Dai Stablecoin',
      image: 'images/token/dai.png',
      active: true,
      decimals: 18,
      chain_id: 137,
    },
    {
      address: '0x5d146d8b1dacb1ebba5cb005ae1059da8a1fbf57',
      symbol: 'CADC',
      name: 'CAD Coin',
      image: 'images/token/cadc.png',
      active: true,
      decimals: 18,
      chain_id: 137,
    },
    {
      address: '0xe111178a87a3bff0c8d18decba5798827539ae99',
      symbol: 'EURS',
      name: 'STASIS EURS Token',
      image: 'images/token/eurs.png',
      active: true,
      decimals: 2,
      chain_id: 137,
    },
  ],

  4: [
    {
      address: '0x01BE23585060835E02B77ef475b0Cc51aA1e0709',
      symbol: 'LINK',
      name: 'ChainLink',
      image: 'images/token/link.png',
      active: true,
      decimals: 18,
      chain_id: 4,
    },
  ],

  56: [
    {
      address: '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56',
      symbol: 'BUSD',
      name: 'Binance-Peg BUSD Token',
      image: 'images/token/busd.png',
      active: true,
      decimals: 18,
      chain_id: 56,
    },
  ],

  5: [
    {
      address: '0xBA62BCfcAaFc6622853cca2BE6Ac7d845BC0f2Dc',
      symbol: 'FAU',
      name: 'Token',
      image: 'images/token/usdc.png',
      active: true,
      decimals: 18,
      chain_id: 5,
    },
  ],
  10: [
    {
      address: '0x7F5c764cBc14f9669B88837ca1490cCa17c31607',
      symbol: 'USDC',
      name: 'USD Coin',
      image: 'images/token/usdc.png',
      active: true,
      decimals: 6,
      chain_id: 10,
    },
    {
      address: '0x94b008aA00579c1307B0EF2c499aD98a8ce58e58',
      symbol: 'USDT',
      name: 'Tether USD',
      image: 'images/token/usdt.png',
      active: true,
      decimals: 6,
      chain_id: 10,
    },
    {
      address: '0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1',
      symbol: 'DAI',
      name: 'Dai Stablecoin',
      image: 'images/token/dai.png',
      active: true,
      decimals: 18,
      chain_id: 10,
    },
  ],
  42161: [
    {
      address: '0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8',
      symbol: 'USDC',
      name: 'USD Coin',
      image: 'images/token/usdc.png',
      active: true,
      decimals: 6,
      chain_id: 42161,
    },
    {
      address: '0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9',
      symbol: 'USDT',
      name: 'Tether USD',
      image: 'images/token/usdt.png',
      active: true,
      decimals: 6,
      chain_id: 42161,
    },
    {
      address: '0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1',
      symbol: 'DAI',
      name: 'Dai Stablecoin',
      image: 'images/token/dai.png',
      active: true,
      decimals: 18,
      chain_id: 42161,
    },
  ],
};
