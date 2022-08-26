import { starknet } from 'hardhat';
import { expect } from 'chai';

import { number, uint256 } from 'starknet';

export type Uint256WithFelts = {
  low: BigInt;
  high: BigInt;
};

/**
 * To use uint256 with cairo, low and high fields must be felts (not sure if there is an library to help here)
 * @param num
 * @returns
 */
export function uint256Felts(num: number.BigNumberish): Uint256WithFelts {
  const n = uint256.bnToUint256(num);
  return {
    low: BigInt(n.low.toString()),
    high: BigInt(n.high.toString()),
  };
}

/**
 * Used to reverse toUint256WithFelts
 * @param uint256WithFelts
 * @returns
 */
export function fromUint256WithFelts(
  uint256WithFelts: Uint256WithFelts
): number.BigNumberish {
  return uint256.uint256ToBN({
    low: uint256WithFelts.low.toString(),
    high: uint256WithFelts.high.toString(),
  });
}
/** Cairo Field Element Arrays allow for much bigger strings (up to 2^15 characters) and manipulation is implemented on-chain **/

/**
 * Splits a string into an array of short strings (felts). A Cairo short string (felt) represents up to 31 utf-8 characters.
 * @param {string} str - The string to convert
 * @returns {bigint[]} - The string converted as an array of short strings as felts
 */
export function strToFeltArr(str: string): BigInt[] {
  const size = Math.ceil(str.length / 31);
  const arr = Array(size);

  let offset = 0;
  for (let i = 0; i < size; i++) {
    const substr = str.substring(offset, offset + 31).split('');
    const ss = substr.reduce(
      (memo, c) => memo + c.charCodeAt(0).toString(16),
      ''
    );
    arr[i] = BigInt('0x' + ss);
    offset += 31;
  }
  return arr;
}

describe('Nft', function () {
  this.timeout(300_000); // 5 min - recommended if used with Alpha testnet (alpha-goerli)
  describe('Initial setup', () => {
    const name = strToFeltArr('test');
    const symbol = strToFeltArr('TEST');
    const maxSupply = uint256Felts('1');
    // const to = starknet.getWallet('admin');

    it('test', async () => {
      const contractFactory = await starknet.getContractFactory('Nft');
      const contract = await contractFactory.deploy({
        name,
        symbol,
        ['_max_supply']: maxSupply,
      });

      const setMaxSupply = await contract.call('maxSupply');
      const setName = await contract.call('name');
      const setSymbol = await contract.call('symbol');

      expect(maxSupply.toString()).to.be.eq(setMaxSupply.toString());
      expect(name[0]).to.be.eq(setName.name);
      expect(symbol[0]).to.be.eq(setSymbol.symbol);
    });
  });
});
