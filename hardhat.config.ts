import '@shardlabs/starknet-hardhat-plugin';
import { HardhatUserConfig } from 'hardhat/types';
require('dotenv').config();

const ACCOUNT_PATH = process.env.ACCOUNT_PATH || '';
const CAIRO_PATH = process.env.CAIRO_PATH || '';

const config: HardhatUserConfig = {
  starknet: {
    venv: process.env.ENV,
    network: 'integrated-devnet',
    recompile: true,
    wallets: {
      admin: {
        accountName: 'admin',
        modulePath:
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',

        accountPath: ACCOUNT_PATH,
      },
    },
    // dockerizedVersion: '0.8.1',
  },
  paths: {
    cairoPaths: ['./node_modules', CAIRO_PATH],
    artifacts: './artifacts',
    cache: './cache',
    sources: './solidity-contracts',
    tests: './tests/hardhat',
    starknetSources: './contracts',
    starknetArtifacts: './starknet-artifacts',
  },
  networks: {
    devnet: {
      url: 'http://localhost:5050',
    },
    alpha: {
      url: 'https://alpha4.starknet.io',
    },
    goerli: {
      url: 'https://goerli.infura.io/v3/70c7fc7307034433a706556377bd1fc6',
      accounts: [
        '2e3fadfb06f25006860589bfacf52d7eb694b65a1dcdc1d0e66e5d008ccd0b97',
      ],
    },
    hardhat: {},
  },
};

export default config;
