%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.security.safemath.library import SafeUint256
from starkware.starknet.common.syscalls import get_caller_address
from openzeppelin.access.ownable.library import Ownable

@storage_var
func total_supply() -> (res : Uint256):
end

@storage_var
func max_supply() -> (res : Uint256):
end

#
# Constructor
#

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    name : felt, symbol : felt, _max_supply : Uint256
):
    let (caller_address) = get_caller_address()

    ERC721.initializer(name, symbol)
    max_supply.write(_max_supply)
    Ownable.initializer(caller_address)

    return ()
end

#
# Getters
#

@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
    let (name) = ERC721.name()
    return (name)
end

@view
func maxSupply{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    max_supply : Uint256
):
    let (maxSupply) = max_supply.read()
    return (maxSupply)
end

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (symbol : felt):
    let (symbol) = ERC721.symbol()
    return (symbol)
end

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(owner : felt) -> (
    balance : Uint256
):
    let (balance : Uint256) = ERC721.balance_of(owner)
    return (balance)
end

@view
func ownerOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    token_id : Uint256
) -> (owner : felt):
    let (owner : felt) = ERC721.owner_of(token_id)
    return (owner)
end

@view
func getApproved{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    token_id : Uint256
) -> (approved : felt):
    let (approved : felt) = ERC721.get_approved(token_id)
    return (approved)
end

@view
func isApprovedForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, operator : felt
) -> (is_approved : felt):
    let (is_approved : felt) = ERC721.is_approved_for_all(owner, operator)
    return (is_approved)
end

#
# Externals
#

@external
func approve{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    to : felt, token_id : Uint256
):
    ERC721.approve(to, token_id)
    return ()
end

@external
func setApprovalForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    operator : felt, approved : felt
):
    ERC721.set_approval_for_all(operator, approved)
    return ()
end

@external
func transferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    _from : felt, to : felt, token_id : Uint256
):
    ERC721.transfer_from(_from, to, token_id)
    return ()
end

@external
func safeTransferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    _from : felt, to : felt, token_id : Uint256, data_len : felt, data : felt*
):
    ERC721.safe_transfer_from(_from, to, token_id, data_len, data)
    return ()
end

@view
func tokenURI{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tokenId : Uint256
) -> (tokenURI : felt):
    let (tokenURI : felt) = ERC721.token_uri(tokenId)
    return (tokenURI)
end

@external
func setTokenURI{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    tokenId : Uint256, tokenURI : felt
):
    Ownable.assert_only_owner()
    ERC721._set_token_uri(tokenId, tokenURI)
    return ()
end

@external
func mint{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(_to : felt) -> (
    id : Uint256
):
    alloc_locals
    let (total_sup) = total_supply.read()
    local token_id : Uint256 = total_sup
    let (max_sup) = max_supply.read()
    let (available_tokens : Uint256) = SafeUint256.sub_le(token_id, max_sup)
    let (have_tokens) = uint256_eq(available_tokens, Uint256(low=0, high=0))

    with_attr error_message("All tokens are minted. total_supply: {total_sup}."):
        assert have_tokens = 1
    end

    ERC721._mint(_to, token_id)
    let (new_total) = SafeUint256.add(total_sup, Uint256(low=1, high=0))
    total_supply.write(new_total)

    return (total_sup)
end
