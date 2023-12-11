# Fabric Image (Comprehensive Way)

## Installation

>First clone the Official Fabric sample.

```bash
git clone https://github.com/hyperledger/fabric-samples.git
cd fabric-samples/test-network
```
Go through the folders and observe the structure and filsystem.

## Requirements
1. Docker/ Docker-compose
2. Docker Desktop (optional but recommended)

## Running the images

>> **Start the test network**
```bash
./network.sh up createChannel
```

>> **SETUP LOGSPOUT (optional)**
```bash
./monitordocker.sh fabric_test
```

Output (on success):
```
<-- OUTPUT -->

Starting monitoring on all containers on the network net_basic
Unable to find image 'gliderlabs/logspout:latest' locally
latest: Pulling from gliderlabs/logspout
4fe2ade4980c: Pull complete
decca452f519: Pull complete
ad60f6b6c009: Pull complete
Digest: sha256:374e06b17b004bddc5445525796b5f7adb8234d64c5c5d663095fccafb6e4c26
Status: Downloaded newer image for gliderlabs/logspout:latest
1f99d130f15cf01706eda3e1f040496ec885036d485cb6bcc0da4a567ad84361

```

>> **FOR "GO":**

> Navigate to the folder that contains the Go version of the asset-transfer (basic) chaincode
```bash
cd fabric-samples/asset-transfer-basic/chaincode-go
cat go.mod
```
Output (on success):
```
<-- OUTPUT -->

module github.com/hyperledger/fabric-samples/asset-transfer-basic/chaincode-go

go 1.14

require (
        github.com/golang/protobuf v1.3.2
        github.com/hyperledger/fabric-chaincode-go v0.0.0-20200424173110-d7076418f212
        github.com/hyperledger/fabric-contract-api-go v1.1.0
        github.com/hyperledger/fabric-protos-go v0.0.0-20200424173316-dd554ba3746e
        github.com/stretchr/testify v1.5.1
)
```

> Install the smart contract dependencies,
```bash
GO111MODULE=on go mod vendor
```

>  Navigate back to our working directory in the test-network folder
```bash
cd ../../test-network
```

> Add the binaries to your CLI **Path**. Set the **FABRIC_CFG_PATH** to point to the core.yaml file in the fabric-samples repository
```bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
peer version
```

Output (on success):
```
<-- OUTPUT -->

peer:
 Version: v2.5.4
 Commit SHA: e1e8e2e
 Go version: go1.20.6
 OS/Arch: linux/amd64
 Chaincode:
  Base Docker Label: org.hyperledger.fabric
  Docker Namespace: hyperledger
```

> Create the chaincode package.
```bash
peer lifecycle chaincode package basic.tar.gz --path ../asset-transfer-basic/chaincode-go/ --lang golang --label basic_1.0
```
This command will create a package named basic.tar.gz in your current directory
```bash
# Analyze the folders
ls
```

>> **INSTALL THE CHAINCODE PACKAGES**

>  Install the chaincode on the Org1 peer first. Set the following environment variables to operate the peer CLI as the Org1 admin user

```bash
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
```

> Issue the peer lifecycle chaincode install command to install the chaincode on the peer

```bash
peer lifecycle chaincode install basic.tar.gz
```

Output (on success):
```
<-- OUTPUT -->

2023-12-11 16:55:14.284 IST 0001 INFO [cli.lifecycle.chaincode] submitInstallProposal -> Installed remotely: response:<status:200 payload:"\nJbasic_1.0:e4de097efb5be42d96aebc4bde18eea848aad0f5453453ba2aad97f2e41e0d57\022\tbasic_1.0" > 
2023-12-11 16:55:14.284 IST 0002 INFO [cli.lifecycle.chaincode] submitInstallProposal -> Chaincode code package identifier: basic_1.0:e4de097efb5be42d96aebc4bde18eea848aad0f5453453ba2aad97f2e41e0d57
```

> Set the following environment variables to operate as the Org2 admin and target the Org2 peer, peer0.org2.example.com

```bash
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
```

> Install the chaincode
```bash
peer lifecycle chaincode install basic.tar.gz
```

>> APPROVE CHAINCODE DEFINITION

>  Find the **package ID** of a chaincode by using the peer lifecycle chaincode queryinstalled command to query your peer

```bash
peer lifecycle chaincode queryinstalled
```

Output (on success):
```
<-- OUTPUT -->

Installed chaincodes on peer:
Package ID: basic_1.0:e4de097efb5be42d96aebc4bde18eea848aad0f5453453ba2aad97f2e41e0d57, Label: basic_1.0
```


```bash
export CC_PACKAGE_ID=basic_1.0:e4de097efb5be42d96aebc4bde18eea848aad0f5453453ba2aad97f2e41e0d57
```

> Approve the chaincode definition using the peer lifecycle chaincode approveformyorg command

```bash
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
```

Output (on success):
```
<-- OUTPUT -->

2023-12-11 16:58:08.748 IST 0001 INFO [chaincodeCmd] ClientWait -> txid [25f90558bb65e4fff8eeb0ec41c9d6de2a8a06c1f07c15cbb81466adc4304c89] committed with status (VALID) at localhost:7051
```

> Need to approve the chaincode definition as Org1. Set the following environment variables to operate as the Org1 admin

```bash
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051
```

> Approve the chaincode definition as Org1
```bash
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
```

>> COMMITING THE CHAINCODE DEFINITION TO THE CHANNEL


```bash
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name basic --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --output json
```

The command will produce a JSON map that displays if a channel member has approved the parameters that were specified in the checkcommitreadiness command

Output (on success):
```
<-- OUTPUT -->

{
	"Approvals": {
		"Org1MSP": true,
		"Org2MSP": true
	}
}
```
> The commit command also needs to be submitted by an organization admin.

```bash
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"
```

Output (on success):
```
<-- OUTPUT -->

2023-12-11 16:58:27.840 IST 0001 INFO [chaincodeCmd] ClientWait -> txid [ec20bf2b5f312b4670b4e21a417d9bd550fae38dcd9404ec4ffcdab22b26c4f4] committed with status (VALID) at localhost:9051
2023-12-11 16:58:27.841 IST 0002 INFO [chaincodeCmd] ClientWait -> txid [ec20bf2b5f312b4670b4e21a417d9bd550fae38dcd9404ec4ffcdab22b26c4f4] committed with status (VALID) at localhost:7051
```

> You can use the peer lifecycle chaincode querycommitted command to confirm that the chaincode definition has been committed to the channel.

```bash
peer lifecycle chaincode querycommitted --channelID mychannel --name basic --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
```
Output (on success):
```
<-- OUTPUT -->

Committed chaincode definition for chaincode 'basic' on channel 'mychannel':
Version: 1.0, Sequence: 1, Endorsement Plugin: escc, Validation Plugin: vscc, Approvals: [Org1MSP: true, Org2MSP: true]
```

>> **INVOKING CHAINCODE**

> Note that the invoke command needs to target a sufficient number of peers to meet the chaincode endorsement policy.

```bash
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'
```
Output (on success):
```
<-- OUTPUT -->

2023-12-11 16:58:47.861 IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 
```

> Query function to read the set of cars that were created by the chaincode

```bash
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'
```
Output (on success):
```
<-- OUTPUT -->

[{"AppraisedValue":300,"Color":"blue","ID":"asset1","Owner":"Tomoko","Size":5},{"AppraisedValue":400,"Color":"red","ID":"asset2","Owner":"Brad","Size":5},{"AppraisedValue":500,"Color":"green","ID":"asset3","Owner":"Jin Soo","Size":10},{"AppraisedValue":600,"Color":"yellow","ID":"asset4","Owner":"Max","Size":10},{"AppraisedValue":700,"Color":"black","ID":"asset5","Owner":"Adriana","Size":15},{"AppraisedValue":800,"Color":"white","ID":"asset6","Owner":"Michel","Size":15}] 
```

## Resources
* [Hyperledger Docs](https://hyperledger-fabric.readthedocs.io/en/release-2.5/deploy_chaincode.html) (Must read)


## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.