#import "storage.mligo" "Storage"
#import "parameter.mligo" "Parameter"
#import "generic_fa2/core/instance/NFT.mligo" "NFT_FA2"

type storage = Storage.t
type parameter = Parameter.t
type return = operation list * storage

type store = NFT_FA2.Storage.t
type ext = NFT_FA2.extension
type ext_storage = ext store

[@entry]
let generateCollection (param : Parameter.generate_collection_param) (store : storage) : return = 
    // create new collection
    let token_ids = param.token_ids in
    let sender = Tezos.get_sender () in
    let ledger = (Big_map.empty : NFT_FA2.Storage.Ledger.t) in
    let myfunc(acc, elt : NFT_FA2.Storage.Ledger.t * nat) : NFT_FA2.Storage.Ledger.t = Big_map.add elt sender acc in
    let new_ledger : NFT_FA2.Storage.Ledger.t = List.fold myfunc token_ids ledger in

    let token_usage = (Big_map.empty : NFT_FA2.TokenUsage.t) in
    let initial_usage(acc, elt : NFT_FA2.TokenUsage.t * nat) : NFT_FA2.TokenUsage.t = Big_map.add elt 0n acc in
    let new_token_usage = List.fold initial_usage token_ids token_usage in

    let token_metadata = param.token_metas in
    let operators = (Big_map.empty : NFT_FA2.Storage.Operators.t) in
    

    let initial_storage : ext_storage = {
        ledger=new_ledger;
        operators=operators;
        token_ids=token_ids;
        token_metadata=token_metadata;
        extension = {
          admin=sender;
          token_usage=new_token_usage;
        }
    }  in 

    let initial_delegate : key_hash option = (None: key_hash option) in
    let initial_amount : tez = 1tez in
    let originate : operation * address = [%create_contract_of_file "generic_fa2/compiled/fa2_nft.tz"] initial_delegate initial_amount initial_storage in
    // insert into collections
    let new_all_collections = Big_map.add originate.1 sender store.all_collections in
    // insert into owned_collections
    let new_owned_collections = match Big_map.find_opt sender store.owned_collections with
    | None -> Big_map.add sender ([originate.1]: address list) store.owned_collections
    | Some addr_lst -> Big_map.update sender (Some(originate.1 :: addr_lst)) store.owned_collections
    in
    ([originate.0], { store with all_collections=new_all_collections; owned_collections=new_owned_collections})

[@entry]
let nothing (_ : unit) (s : storage) : return = (([] : operation list), s)