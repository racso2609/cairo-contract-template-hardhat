import { starknet } from 'hardhat';
import { expect } from 'chai';

describe('My Test', function () {
  it('test', async () => {
    const wallet = starknet.getWallet('admin');
    console.log(wallet);
    expect(true);
  });
});
