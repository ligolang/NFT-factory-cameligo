type collectionContract = address
type collectionOwner = address

type t = {
    all_collections : (collectionContract, collectionOwner) big_map;
    owned_collections : (collectionOwner, collectionContract list) big_map;
    metadata: (string, bytes) big_map;
}

