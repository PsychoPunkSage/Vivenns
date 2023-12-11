# Fabric Image (Direct Way)

## Installation

>First clone the Official Fabric sample.

```bash
git clone https://github.com/hyperledger/fabric-samples.git
cd fabric-samples
```
Go through the folders and observe the structure and filsystem.

## Requirements
1. Docker/ Docker-compose
2. Docker Desktop (optional but recommended)

## Running the images
>> **SETTING UP THE NETWORK**

> Get inside **test-network**
```bash
cd fabric-samples/test-network
```

> **Precaution** (not required for 1st time)
```bash
cd fabric-samples/test-network
```

if by any chance it doesn't work. Run
```bash
# Optional
chmod +x network.sh
```

> Get network up.
```bash
./network.sh up
```

Output (on success):
```
<-- OUTPUT -->

Creating network "fabric_test" with the default driver
Creating volume "net_orderer.example.com" with default driver
Creating volume "net_peer0.org1.example.com" with default driver
Creating volume "net_peer0.org2.example.com" with default driver
Creating peer0.org2.example.com ... done
Creating orderer.example.com    ... done
Creating peer0.org1.example.com ... done
Creating cli                    ... done
CONTAINER ID   IMAGE                               COMMAND             CREATED         STATUS                  PORTS                                            NAMES
1667543b5634   hyperledger/fabric-tools:latest     "/bin/bash"         1 second ago    Up Less than a second                                                    cli
b6b117c81c7f   hyperledger/fabric-peer:latest      "peer node start"   2 seconds ago   Up 1 second             0.0.0.0:7051->7051/tcp                           peer0.org1.example.com
703ead770e05   hyperledger/fabric-orderer:latest   "orderer"           2 seconds ago   Up Less than a second   0.0.0.0:7050->7050/tcp, 0.0.0.0:7053->7053/tcp   orderer.example.com
718d43f5f312   hyperledger/fabric-peer:latest      "peer node start"   2 seconds ago   Up 1 second             7051/tcp, 0.0.0.0:9051->9051/tcp                 peer0.org2.example.com
```

> Check whether the container is running or not.
```bash
docker ps -a
```

>> **CREATING A CHANNEL**

```bash
./network.sh createChannel
```

Output (on success):
```
<-- OUTPUT -->
......
Channel 'mychannel' joined
```

To create coustom channel;
also one can create multiple channels (not required though)
```bash
./network.sh createChannel -c channel1
./network.sh createChannel -c channel2
```

### Shortcut till now
```bash
./network.sh up createChannel
```

>> **STARTING CHAINCODE IN CHANNEL**
```bash
./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl {PreferredLang: go/typescript/javascript}
```

>> **INTERACTING WITH NETWORK** <br>

> Adding binaries to CLI **Path**
```bash
export PATH=${PWD}/../bin:$PATH
```

> set the **FABRIC_CFG_PATH** to point to the core.yaml file in the fabric-samples repository
```bash
export FABRIC_CFG_PATH=$PWD/../config/
```

> set the environment variables that allow you to operate the peer CLI as Org1
```bash
# Environment variables for Org1

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
```
The **CORE_PEER_TLS_ROOTCERT_FILE** and **CORE_PEER_MSPCONFIGPATH** environment variables point to the Org1 crypto material in the organizations folder.

> initialize the ledger with assets
```bash
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'
```

Output (on success)
```
<-- OUTPUT -->
-> INFO 001 Chaincode invoke successful. result: status:200
```

>  Get the list of assets that were added to your channel ledger
```bash
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'
```

Output (on success)
```
<-- OUTPUT -->
[
  {"ID": "asset1", "color": "blue", "size": 5, "owner": "Tomoko", "appraisedValue": 300},
  {"ID": "asset2", "color": "red", "size": 5, "owner": "Brad", "appraisedValue": 400},
  {"ID": "asset3", "color": "green", "size": 10, "owner": "Jin Soo", "appraisedValue": 500},
  {"ID": "asset4", "color": "yellow", "size": 10, "owner": "Max", "appraisedValue": 600},
  {"ID": "asset5", "color": "black", "size": 15, "owner": "Adriana", "appraisedValue": 700},
  {"ID": "asset6", "color": "white", "size": 15, "owner": "Michel", "appraisedValue": 800}
]
```

> Change the owner of an asset on the ledger by **invoking** the **asset-transfer (basic)** chaincode

```bash
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"TransferAsset","Args":["asset6","Christopher"]}'
```

Output (on success)
```
<-- OUTPUT -->
2019-12-04 17:38:21.048 EST [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 001 Chaincode invoke successful. result: status:200
```

> Set the following environment variables to operate as Org2
```bash
# Environment variables for Org2

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
```

> Query the asset-transfer (basic) chaincode running on peer0.org2.example.com
```bash
query the asset-transfer (basic) chaincode running on peer0.org2.example.com
```

Output (in success)
```
<-- OUTPUT -->
{"ID":"asset6","color":"white","size":15,"owner":"Christopher","appraisedValue":800}
```


>> **BRING DOWN THE NETWORK**
```bash
./network.sh down
```

## Resources
* [Hyperledger Docs](https://hyperledger-fabric.readthedocs.io/en/release-2.5/test_network.html) (Must read)


## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.