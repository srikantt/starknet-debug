%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address

struct BasicStruct {
    first_member: felt,
    second_member: felt,
}

@view
func view_product{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    arr_len: felt, arr: BasicStruct*
) -> (res: felt) {
    // This could be useful for debugging...
    let val = [arr];
    %{
        from requests import post
        json = { # creating the body of the post request so it's printed in the python script
            "first_member": ids.val.first_member,
            "second_member": ids.val.second_member
        }
        post(url="http://localhost:5000", json=json) # sending the request to our small "server"
    %}
    let (res) = array_product(arr_len, arr);
    let (add) = get_contract_address();
    return (res + add,);
}

func array_product{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    arr_len: felt, arr: BasicStruct*
) -> (res: felt) {
    if (arr_len == 0) {
        return (0,);
    }
    let temp = [arr].first_member * [arr].second_member;
    let (temp2) = array_product(arr_len - 1, arr);
    let res = temp * temp2;
    return (res,);
}
