# Running Chaincode \<CommandLine>

## Installation

>First clone the Official Fabric sample.

```bash
git clone https://github.com/hyperledger/fabric-samples.git
cd fabric-samples
```
Go through the folders and observe the structure and filsystem.

## Task
> Implement all the Chanicodes function via. Command-line <br>
> **Path::** <br>
***&nbsp;&nbsp;&nbsp;&nbsp;fabric-samples/asset-transfer-basic/chaincode-go/chaincode/smartcontract.go***



## Requirements
1. Docker/ Docker-compose
2. Docker Desktop (optional but recommended) <br>
3. **You MUST turn Network UP...** **[Reference](https://github.com/PsychoPunkSage/Vivenns/blob/Hyperledger/1_running_fabric_images/1_Direct_way.md)**

## Invoke/Query:
>> **1. InitLedger()**

> Get inside **test-network** <br>
You must have **[Approved](https://hyperledger-fabric.readthedocs.io/en/release-2.5/deploy_chaincode.html#approve-a-chaincode-definition)** & **[Committited](https://hyperledger-fabric.readthedocs.io/en/release-2.5/deploy_chaincode.html#committing-the-chaincode-definition-to-the-channel)** the chaincode definition to the channel (Follow the Link if NOT)

```bash
# Command
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'
```

Output (on success):
```
<-- OUTPUT -->

2023-12-13 15:26:21.387 IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 

```

> Check whether it **Actually** worked or not...
```bash
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'
```
Output (on success):
```
<-- OUTPUT -->

[{"AppraisedValue":300,"Color":"blue","ID":"asset1","Owner":"Tomoko","Size":5},{"AppraisedValue":400,"Color":"red","ID":"asset2","Owner":"Brad","Size":5},{"AppraisedValue":500,"Color":"green","ID":"asset3","Owner":"Jin Soo","Size":10},{"AppraisedValue":600,"Color":"yellow","ID":"asset4","Owner":"Max","Size":10},{"AppraisedValue":700,"Color":"black","ID":"asset5","Owner":"Adriana","Size":15},{"AppraisedValue":800,"Color":"white","ID":"asset6","Owner":"Michel","Size":15}]
```

>> **2. CreateAsset** (id, color, size, owner, appraisedValue)<br>

> The data we will be giving as Input (in total **10 datas**)
```
>> ["AP1", "C1", "10001", "PsychoPunkSage", "90001"]
>> ["AP2", "C2", "10002", "PsychoPunkSage", "90002"]
>> ["AP3", "C3", "10003", "PsychoPunkSage", "90003"]
>> ["AP4", "C4", "10004", "PsychoPunkSage", "90004"]
>> ["AP5", "C5", "10005", "PsychoPunkSage", "90005"]
>> ["AP6", "C6", "10006", "PsychoPunkSage", "90006"]
>> ["AP7", "C7", "10007", "PsychoPunkSage", "90007"]
>> ["AP8", "C8", "10008", "PsychoPunkSage", "90008"]
>> ["AP9", "C9", "10009", "PsychoPunkSage", "90009"]
>> ["AP0", "C0", "10000", "PsychoPunkSage", "90000"]
```


```bash
# Command
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"CreateAsset","Args":["AP1", "C1", "10001", "PsychoPunkSage", "90001"]}'
```
In the Above Command, **REPLACE** ["AP1", "C1", "10001", "PPS", "90001"] with the Inputs listed above.... <br>
**Execute the above command 10 times with changes required**<br>

Output (on success):
```
<-- OUTPUT -->

2023-12-13 15:53:57.781 IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 

```

> Check whether it **Actually** worked or not...
```bash
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'
```
Output (on success):
```
<-- OUTPUT -->

[{"AppraisedValue":90000,"Color":"C0","ID":"AP0","Owner":"PsychoPunkSage","Size":10000},{"AppraisedValue":90001,"Color":"C1","ID":"AP1","Owner":"PsychoPunkSage","Size":10001},{"AppraisedValue":90002,"Color":"C2","ID":"AP2","Owner":"PsychoPunkSage","Size":10002},{"AppraisedValue":90003,"Color":"C3","ID":"AP3","Owner":"PsychoPunkSage","Size":10003},{"AppraisedValue":90004,"Color":"C4","ID":"AP4","Owner":"PsychoPunkSage","Size":10004},{"AppraisedValue":90005,"Color":"C5","ID":"AP5","Owner":"PsychoPunkSage","Size":10005},{"AppraisedValue":90006,"Color":"C6","ID":"AP6","Owner":"PsychoPunkSage","Size":10006},{"AppraisedValue":90007,"Color":"C7","ID":"AP7","Owner":"PsychoPunkSage","Size":10007},{"AppraisedValue":90008,"Color":"C8","ID":"AP8","Owner":"PsychoPunkSage","Size":10008},{"AppraisedValue":90009,"Color":"C9","ID":"AP9","Owner":"PsychoPunkSage","Size":10009},{"AppraisedValue":300,"Color":"blue","ID":"asset1","Owner":"Tomoko","Size":5},{"AppraisedValue":400,"Color":"red","ID":"asset2","Owner":"Brad","Size":5},{"AppraisedValue":500,"Color":"green","ID":"asset3","Owner":"Jin Soo","Size":10},{"AppraisedValue":600,"Color":"yellow","ID":"asset4","Owner":"Max","Size":10},{"AppraisedValue":700,"Color":"black","ID":"asset5","Owner":"Adriana","Size":15},{"AppraisedValue":800,"Color":"white","ID":"asset6","Owner":"Michel","Size":15},{"AppraisedValue":1000,"Color":"purple","ID":"asset8","Owner":"John","Size":20}]
```


>> **3. UpdateAsset** (id, color, size, owner, appraisedValue)<br>

> The data we will be Updating
```
to_be_replaced := ["AP0", "C0", "10000", "PsychoPunkSage", "90000"] 
data_will_be_used := ["AP0", "U_C0", "10000", "U_PPS", "90000"]
```


```bash
# Command
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"UpdateAsset","Args": ["AP0", "U_C0", "10000", "U_PsychoPunkSage", "90000"]}'
```
Output (on success):
```
<-- OUTPUT -->

2023-12-13 16:00:02.327 IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 
```


> Check whether it **Actually** worked or not...
```bash
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'
```
Output (on success):
```
<-- OUTPUT -->

[{"AppraisedValue":90000,"Color":"U_C0","ID":"AP0","Owner":"U_PsychoPunkSage","Size":10000},{"AppraisedValue":90001,"Color":"C1","ID":"AP1","Owner":"PPS","Size":10001},{"AppraisedValue":90002,"Color":"C2","ID":"AP2","Owner":"PPS","Size":10002},{"AppraisedValue":90003,"Color":"C3","ID":"AP3","Owner":"PPS","Size":10003},{"AppraisedValue":90004,"Color":"C4","ID":"AP4","Owner":"PPS","Size":10004},{"AppraisedValue":90005,"Color":"C5","ID":"AP5","Owner":"PPS","Size":10005},{"AppraisedValue":90006,"Color":"C6","ID":"AP6","Owner":"PPS","Size":10006},{"AppraisedValue":90007,"Color":"C7","ID":"AP7","Owner":"PPS","Size":10007},{"AppraisedValue":90008,"Color":"C8","ID":"AP8","Owner":"PPS","Size":10008},{"AppraisedValue":90009,"Color":"C9","ID":"AP9","Owner":"PPS","Size":10009},{"AppraisedValue":300,"Color":"blue","ID":"asset1","Owner":"Tomoko","Size":5},{"AppraisedValue":400,"Color":"red","ID":"asset2","Owner":"Brad","Size":5},{"AppraisedValue":500,"Color":"green","ID":"asset3","Owner":"Jin Soo","Size":10},{"AppraisedValue":600,"Color":"yellow","ID":"asset4","Owner":"Max","Size":10},{"AppraisedValue":700,"Color":"black","ID":"asset5","Owner":"Adriana","Size":15},{"AppraisedValue":800,"Color":"white","ID":"asset6","Owner":"Michel","Size":15},{"AppraisedValue":1000,"Color":"purple","ID":"asset8","Owner":"John","Size":20}]

```



>> **4. ReadAsset** (id)<br>

> The data we will be Updating
```
asset_to_be_read := ["asset8"]
```


```bash
# Command
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"ReadAsset","Args": ["asset8"]}'
```
Output (on success):
```
<-- OUTPUT -->

2023-12-13 17:18:07.183 IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 payload:"{\"AppraisedValue\":1000,\"Color\":\"purple\",\"ID\":\"asset8\",\"Owner\":\"John\",\"Size\":20}" 

```

>> **5. DeleteAsset** (id)<br>

> The data we will be Updating
```
asset_to_be_deleted := ["AP1"]
```


```bash
# Command
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"DeleteAsset","Args": ["AP1"]}'
```

Output (on success):
```
<-- OUTPUT -->

2023-12-13 16:02:15.195 IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 

```

> Check whether it **Actually** worked or not...
```bash
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"ReadAsset","Args": ["AP1"]}'
```
Output (on success):
```
<-- OUTPUT -->

Error: endorsement failure during invoke. response: status:500 message:"the asset AP1 does not exist" 
```



>> **BRING DOWN THE NETWORK**
```bash
./network.sh down
```

## Resources
* [Hyperledger Fabric-Sample](https://github.com/hyperledger/fabric-samples) (Go through it)


## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.