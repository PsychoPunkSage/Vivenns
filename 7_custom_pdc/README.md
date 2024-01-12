# Custom Public Data Collections (PDC) \<CommandLine>

## Installation

>First clone the Official Fabric sample.

```bash
git clone https://github.com/hyperledger/fabric-samples.git
cd fabric-samples
```
Go through the folders and observe the structure and filsystem.

## Task
>1. Create a project vehicle lifecycle management with two org.
>2. Use PDC to share data
>3. Create pdc data in org1 and access in org2
>4. Implement chaincode lifecycle and pdc  
 



## Requirements
1. Docker/ Docker-compose
2. Docker Desktop (optional but recommended)
3. [**Chaincode**](https://github.com/PsychoPunkSage/Fabric_Labyrinth/tree/main/asset-transfer-pdc-pps)

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
./network.sh deployCC -ccn private -ccp ../{{{NAME_OF_FOLDER}}}/chaincode-go/ -ccl go -ccep "OR('Org1MSP.peer','Org2MSP.peer')" -cccg ../{{{NAME_OF_FOLDER}}}/chaincode-go/collections_config.json
```
We need to pass the **path to the private data collection** `definition file` to the command. As part of deploying the chaincode to the channel, both organizations on the channel must pass identical private data collection definitions

## Register identities

> Use the Fabric CA client
```bash
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
```

> Use the Org1 CA to create the identity asset owner.
```bash
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/
```

> Register a new owner client identity using the *fabric-ca-client*
```bash
fabric-ca-client register --caname ca-org1 --id.name owner --id.secret ownerpw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/org1/tls-cert.pem"
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

2023/12/29 14:53:49 [INFO] Configuration file location: /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/fabric-ca-client-config.yaml
2023/12/29 14:53:49 [INFO] TLS Enabled
2023/12/29 14:53:49 [INFO] TLS Enabled
Password: ownerpw
```

</details><br>


> Generate the identity certificates and MSP folder
```bash
fabric-ca-client enroll -u https://owner:ownerpw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/tls-cert.pem"
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

2023/12/29 14:54:28 [INFO] TLS Enabled
2023/12/29 14:54:28 [INFO] generating key: &{A:ecdsa S:256}
2023/12/29 14:54:28 [INFO] encoded CSR
2023/12/29 14:54:28 [INFO] Stored client certificate at /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp/signcerts/cert.pem
2023/12/29 14:54:28 [INFO] Stored root CA certificate at /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp/cacerts/localhost-7054-ca-org1.pem
2023/12/29 14:54:28 [INFO] Stored Issuer public key at /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp/IssuerPublicKey
2023/12/29 14:54:28 [INFO] Stored Issuer revocation public key at /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp/IssuerRevocationPublicKey
```

</details><br>

> Copy the Node OU configuration file into the owner identity MSP folder.
```bash
cp "${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp/config.yaml"
```

> Use the Org2 CA to create the buyer identity
```bash
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/
```

> Register a new owner client identity using the *fabric-ca-client*
```bash
fabric-ca-client register --caname ca-org2 --id.name buyer --id.secret buyerpw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/org2/tls-cert.pem"
```
<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

2023/12/29 15:05:29 [INFO] Configuration file location: /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/fabric-ca-client-config.yaml
2023/12/29 15:05:29 [INFO] TLS Enabled
2023/12/29 15:05:29 [INFO] TLS Enabled
Password: buyerpw
```

</details><br>


> Enroll to generate the identity MSP folde
```bash
fabric-ca-client enroll -u https://buyer:buyerpw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/tls-cert.pem"
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

<!-- 2023/12/29 15:07:31 [INFO] TLS Enabled
2023/12/29 15:07:31 [INFO] generating key: &{A:ecdsa S:256}
2023/12/29 15:07:31 [INFO] encoded CSR
2023/12/29 15:07:31 [INFO] Stored client certificate at /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp/signcerts/cert.pem
2023/12/29 15:07:31 [INFO] Stored root CA certificate at /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp/cacerts/localhost-8054-ca-org2.pem
2023/12/29 15:07:31 [INFO] Stored Issuer public key at /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp/IssuerPublicKey
2023/12/29 15:07:31 [INFO] Stored Issuer revocation public key at /home/psychopunk_sage/Hyperledger/Fabric/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp/IssuerRevocationPublicKey -->
```

</details><br>

> Copy the Node OU configuration file into the buyer identity MSP folder.
```bash
cp "${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp/config.yaml"
```

## Create an asset in private data

> Setup 
```bash
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
```

> Create the asset
```bash
export ASSET_PROPERTIES=$(echo -n "{\"vehicleName\":\"Harrier\",\"vehicleNumber\":\"DL00XXXX\",\"vehicleCompany\":\"TATA\",\"vehicleMfgYear\":2020,\"vehicleLife\":14}" | base64 | tr -d \\n)
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"CreateAsset","Args":[]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

2023-12-29 15:11:37.832 IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 
```

</details><br>

## Query the private data

>> **AUTHORIZED PEER**

> Query the private data
```bash
peer chaincode query -C mychannel -n private -c '{"function":"ReadAsset","Args":["DL00XXXX"]}'
```
<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

{"vehicleName":"Harrier","vehicleNumber":"DL00XXXX","vehicleCompany":"TATA","vehicleMfgYear":2020,"owner":"x509::CN=owner,OU=client,O=Hyperledger,ST=North Carolina,C=US::CN=ca.org1.example.com,O=org1.example.com,L=Durham,ST=North Carolina,C=US"}
```

</details><br>

> Query for the appraisedValue private data of asset1 as a member of Org1.
```bash
peer chaincode query -C mychannel -n private -c '{"function":"ReadAssetPrivateDetails","Args":["Org1MSPPrivateCollection","DL00XXXX"]}'

```
<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

{"vehicleNumber":"DL00XXXX","vehicleLife":14}
```

</details><br>

>> **UNAUTHORIZED PEER**

> Switch to peer og Org2
```bash
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
```

> Query private data Org2 is authorized to
```bash
peer chaincode query -C mychannel -n private -c '{"function":"ReadAsset","Args":["asset1"]}'
```
<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

{"objectType":"asset","assetID":"asset1","color":"green","size":20,"owner":"x509::CN=owner,OU=client,O=Hyperledger,ST=North Carolina,C=US::CN=ca.org1.example.com,O=org1.example.com,L=Durham,ST=North Carolina,C=US"}
```

</details><br>

> Query private data Org2 is not authorized to
```bash
peer chaincode query -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n private -c '{"function":"ReadAssetPrivateDetails","Args":["Org2MSPPrivateCollection","asset1"]}'
```
output > Nothing
The empty response shows that the asset1 private details do not exist in buyer (Org2) private collection.

> Nor can a user from Org2 read the Org1 private data collection
```bash
peer chaincode query -C mychannel -n private -c '{"function":"ReadAssetPrivateDetails","Args":["Org1MSPPrivateCollection","asset1"]}'
```

<details>
<summary>Output (on success)</summary>

```
<-- OUTPUT -->

Error: endorsement failure during query. response: status:500 message:"failed to read asset details: GET_STATE failed: transaction ID: 3e5281979ce86075ce9f8176259283ddecbb75fbd672f1dc5dc7faf9be3716df: tx creator does not have read access permission on privatedata in chaincodeName:private collectionName: Org1MSPPrivateCollection"
```

</details><br>




## Clean up
> Turn down the network.
```bash
./network.sh down
```

## Resources
* [Fabric - Private Data](https://hyperledger-fabric.readthedocs.io/en/release-2.5/private-data/private-data.html) (Must read)
* [Private Data in Fabric](https://hyperledger-fabric.readthedocs.io/en/release-2.5/private_data_tutorial.html) (Must read)
* [Chaincode - Used here](https://github.com/PsychoPunkSage/Fabric_Labyrinth/tree/main/asset-transfer-pdc-pps)


## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.