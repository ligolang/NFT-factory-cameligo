type collectionContract = address
type collectionOwner = address

type t = {
    all_collections : (collectionContract, collectionOwner) big_map;
    owned_collections : (collectionOwner, collectionContract list) big_map;
    metadata: (string, bytes) big_map;
}

let initial_storage () = {
    all_collections = (Big_map.empty : (collectionContract, collectionOwner) big_map);
    owned_collections = (Big_map.empty : (collectionOwner, collectionContract list) big_map);
    metadata = (Big_map.empty : (string, bytes) big_map);
}
