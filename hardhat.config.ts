import '@shardlabs/starknet-hardhat-plugin'
import { HardhatUserConfig } from 'hardhat/types'

const config: HardhatUserConfig = {
  starknet: {
    network: 'integrated-devnet',
    recompile: true,
    wallets: {
      admin: {
        accountName: 'admin',
        modulePath:
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',

        accountPath: '~/.starknet_accounts',
      },
    },
  },
  paths: {
    cairoPaths: ['./node_modules', '~/cairo_venv/lib/python3.7/site-packages'],
  },
}

export default config
