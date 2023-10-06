#import "generic_fa2/core/instance/NFT.mligo" "NFT_FA2"

type generate_collection_param = {
    name : string;
    token_ids : nat list;
    token_metas : NFT_FA2.NFT.TokenMetadata.t
}

type t = generate_collection_param