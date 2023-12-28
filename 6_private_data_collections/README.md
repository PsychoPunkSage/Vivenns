# Public Data Collections (PDC) \<CommandLine>

## Installation

>First clone the Official Fabric sample.

```bash
git clone https://github.com/hyperledger/fabric-samples.git
cd fabric-samples
```
Go through the folders and observe the structure and filsystem.

## Task
> Implement all the Chanicodes function of **asset-transfer-private-data** via. Command-line <br>
> **Path::** <br>
***&nbsp;&nbsp;&nbsp;&nbsp;fabric-samples/asset-transfer-private-data/chaincode-go/chaincode/asset_queries.go***



## Requirements
1. Docker/ Docker-compose
2. Docker Desktop (optional but recommended)

## Start the network
```bash
cd fabric-samples/test-network
./network.sh down
```
> Start up the Fabric test network with **`CA`** and **`CouchDB`**
```bash
./network.sh up createChannel -ca -s couchdb
```

## Deploy the PD smart contract to the channel
```bash
./network.sh deployCC -ccn private -ccp ../asset-transfer-private-data/chaincode-go/ -ccl go -ccep "OR('Org1MSP.peer','Org2MSP.peer')" -cccg ../asset-transfer-private-data/chaincode-go/collections_config.json
```
We need to pass the **path to the private data collection** `definition file` to the command. As part of deploying the chaincode to the channel, both organizations on the channel must pass identical private data collection definitions

## Register identities

## Create an asset in private data

## Query the private data

## Transfer the Asset

To transfer an asset, the buyer (recipient) needs to agree to the same `appraisedValue` as the asset owner, by calling chaincode function **`AgreeToTransfer`**

> Agreeing to given `appraisedValue` \<as Org2>
```bash
export ASSET_VALUE=$(echo -n "{\"assetID\":\"asset1\",\"appraisedValue\":100}" | base64 | tr -d \\n)
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"AgreeToTransfer","Args":[]}' --transient "{\"asset_value\":\"$ASSET_VALUE\"}"
```

> Buyer can now query the value they agreed
```bash
peer chaincode query -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"ReadAssetPrivateDetails","Args":["Org2MSPPrivateCollection","asset1"]}'
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

{"assetID":"asset1","appraisedValue":100}
```

</details><br>

> Lets act as \<Org1> to transfer asset
```bash
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051
```

> **Owner** from \<Org1> can read the data added by the **`AgreeToTransfer`** transaction to view the buyer identity

```bash
peer chaincode query -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"ReadTransferAgreement","Args":["asset1"]}'
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

{"assetID":"asset1","buyerID":"eDUwOTo6Q049YnV5ZXIsT1U9Y2xpZW50LE89SHlwZXJsZWRnZXIsU1Q9Tm9ydGggQ2Fyb2xpbmEsQz1VUzo6Q049Y2Eub3JnMi5leGFtcGxlLmNvbSxPPW9yZzIuZXhhbXBsZS5jb20sTD1IdXJzbGV5LFNUPUhhbXBzaGlyZSxDPVVL"}
```

</details><br>

> Transfer the Asset
```bash
export ASSET_OWNER=$(echo -n "{\"assetID\":\"asset1\",\"buyerMSP\":\"Org2MSP\"}" | base64 | tr -d \\n)
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"TransferAsset","Args":[]}' --transient "{\"asset_owner\":\"$ASSET_OWNER\"}" --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"
```
> See result of Asset Transfer
```bash
peer chaincode query -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"ReadAsset","Args":["asset1"]}'
```
<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

{"objectType":"asset","assetID":"asset1","color":"green","size":20,"owner":"x509::CN=appUser2, OU=client + OU=org2 + OU=department1::CN=ca.org2.example.com, O=org2.example.com, L=Hursley, ST=Hampshire, C=UK"}
```

</details><br>

**The “owner” of the asset now has the buyer identity.**

> Confirmation
```bash
peer chaincode query -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"ReadAssetPrivateDetails","Args":["Org1MSPPrivateCollection","asset1"]}'
```
<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->


```

</details><br>



## Purge Private Data
>> **BECOME \<Org2> PEER**
```bash
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
```
>> **RUN COMMANDS AS PEER OF \<Org2>**

This is done because currently **Org2** is the owner of *asset*.

> **Check** whether we can still query the `appraisedValue` in the `Org2MSPPrivateCollection`

```bash
peer chaincode query -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"ReadAssetPrivateDetails","Args":["Org2MSPPrivateCollection","asset1"]}'
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

{"assetID":"asset1","appraisedValue":100}
```

</details><br>

We need to keep track of how many blocks we are adding before the private data gets purged, open a new terminal window and run the following command:

```bash
docker logs peer0.org1.example.com 2>&1 | grep -i -a -E 'private|pvt|privdata'
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

.....
2023-12-28 11:37:07.913 UTC 009e INFO [endorser] callChaincode -> finished chaincode: private duration: 2ms channel=mychannel txID=b76011d3
2023-12-28 11:37:20.658 UTC 00a0 INFO [endorser] callChaincode -> finished chaincode: private duration: 6ms channel=mychannel txID=2c51ede1
```

</details><br>

> Create **three** new assets
#### Asset1
```bash
export ASSET_PROPERTIES=$(echo -n "{\"objectType\":\"asset\",\"assetID\":\"asset2\",\"color\":\"blue\",\"size\":30,\"appraisedValue\":100}" | base64 | tr -d \\n)
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"CreateAsset","Args":[]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"
```

#### Asset2
```bash
export ASSET_PROPERTIES=$(echo -n "{\"objectType\":\"asset\",\"assetID\":\"asset3\",\"color\":\"red\",\"size\":25,\"appraisedValue\":100}" | base64 | tr -d \\n)
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"CreateAsset","Args":[]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"
```

#### Asset3
```bash
export ASSET_PROPERTIES=$(echo -n "{\"objectType\":\"asset\",\"assetID\":\"asset4\",\"color\":\"orange\",\"size\":15,\"appraisedValue\":100}" | base64 | tr -d \\n)
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"CreateAsset","Args":[]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"
```

> **Check** whether 3 blocks are created or not
```bash
docker logs peer0.org1.example.com 2>&1 | grep -i -a -E 'private|pvt|privdata'
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

.....
2023-12-28 11:39:51.907 UTC 00a2 INFO [gossip.privdata] StoreBlock -> Received block [9] from buffer channel=mychannel
2023-12-28 11:39:51.911 UTC 00a4 INFO [gossip.privdata] RetrievePvtdata -> Successfully fetched (or marked to reconcile later) all 1 eligible collection private write sets for block [9] (0 from local cache, 1 from transient store, 0 from other peers) channel=mychannel
2023-12-28 11:39:51.974 UTC 00a5 INFO [kvledger] commit -> [mychannel] Committed block [9] with 1 transaction(s) in 63ms (state_validation=8ms block_and_pvtdata_commit=10ms state_commit=42ms) commitHash=[0e8d4a818db2b3478b8bd216913085d6906dc98ca86f6e5f27ef7a6097e28d54]
2023-12-28 11:39:58.884 UTC 00a6 INFO [gossip.privdata] StoreBlock -> Received block [10] from buffer channel=mychannel
2023-12-28 11:39:58.888 UTC 00a8 INFO [gossip.privdata] RetrievePvtdata -> Successfully fetched (or marked to reconcile later) all 1 eligible collection private write sets for block [10] (0 from local cache, 1 from transient store, 0 from other peers) channel=mychannel
2023-12-28 11:39:58.940 UTC 00a9 INFO [kvledger] commit -> [mychannel] Committed block [10] with 1 transaction(s) in 52ms (state_validation=4ms block_and_pvtdata_commit=9ms state_commit=37ms) commitHash=[724f880c5ea23df2ce5f3060e9bfbe0d7a80f2a9570f584e4b3db777fc9816fc]
2023-12-28 11:40:10.392 UTC 00aa INFO [gossip.privdata] StoreBlock -> Received block [11] from buffer channel=mychannel
2023-12-28 11:40:10.395 UTC 00ac INFO [gossip.privdata] RetrievePvtdata -> Successfully fetched (or marked to reconcile later) all 1 eligible collection private write sets for block [11] (0 from local cache, 1 from transient store, 0 from other peers) channel=mychannel
2023-12-28 11:40:10.444 UTC 00ad INFO [kvledger] commit -> [mychannel] Committed block [11] with 1 transaction(s) in 49ms (state_validation=3ms block_and_pvtdata_commit=8ms state_commit=34ms) commitHash=[4a6ea411da4daba80377819b8f38fabbabc22932dea703c5c704265208ffb147]
```

</details><br>

> **Check** The `appraisedValue` has now been purged from the `Org2MSPDetailsCollection` private data collection

```bash
peer chaincode query -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"ReadAssetPrivateDetails","Args":["Org2MSPPrivateCollection","asset1"]}'
```
<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->


```

</details><br>

## Clean up
> Turn down the network.
```bash
./network.sh down
```