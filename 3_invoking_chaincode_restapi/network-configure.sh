#!/bin/bash

# PATH: save it in `fabric-samples > test-network` i.e. in same location as 'network.sh'

# Starting the network
echo "============================= STARTING NETWORK =============================="
./network.sh up createChannel -ca
echo "=============================== NETWORK IS UP ==============================="


echo "================= SMART CONTRACT DEPENDENCIES INSTALLATION =================="
cd ../asset-transfer-basic/rest-api-go/
GO111MODULE=on go mod vendor

echo "------------------ NAVIGATING BACK TO TEST_NETWORK_FOLDER -------------------"
cd ../../test-network


echo "-------- Add the binaries to your CLI Path. Set the FABRIC_CFG_PATH ---------"
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
peer version


echo "----------------------- Create the chaincode package ------------------------"
peer lifecycle chaincode package basic.tar.gz --path ../asset-transfer-basic/chaincode-go/ --lang golang --label basic_1.0


echo "====================== INSTALL THE CHAINCODE PACKAGES ======================="
echo "------------- Installing the chaincode on the Org1 peer first ---------------"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

echo "------------------- Installing the chaincode on the peer --------------------"
peer lifecycle chaincode install basic.tar.gz

echo "----------- Set the environment variables to operate as the Org2 ------------"
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

echo "------------------- Installing the chaincode on the peer --------------------"
peer lifecycle chaincode install basic.tar.gz


echo "======================= APPROVE CHAINCODE DEFINITION ========================"

# Query installed chaincodes
queryResult=$(peer lifecycle chaincode queryinstalled)

# Check if output is empty
if [ -z "$queryResult" ]; then
  echo "No chaincodes installed"
  exit 1
fi

# Get package ID from output 
packageId=$(echo "$queryResult" | grep -o ':[0-9a-f]\{64\}' | cut -c 2-)

if [ -z "$packageId" ]; then
  echo "Error getting package ID"
  exit 1
fi

# Export package ID as environment variable
export CC_PACKAGE_ID=basic_1.0:$packageId

echo "Package ID: $CC_PACKAGE_ID"


echo "---- Approve the chaincode definition using the peer lifecycle chaincode -----"
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"


echo "------------------ Approve the chaincode definition as Org1 ------------------"
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"



echo "============= COMMITING THE CHAINCODE DEFINITION TO THE CHANNEL ==============="
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name basic --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --output json
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name basic --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"
peer lifecycle chaincode querycommitted --channelID mychannel --name basic --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

echo "============================= INVOKING CHAINCODE ==============================="
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'


echo "--------------------------------------------------------------------------------"
echo "=========================== NETWORK SETUP COMPLETE ============================="
echo "--------------------------------------------------------------------------------"