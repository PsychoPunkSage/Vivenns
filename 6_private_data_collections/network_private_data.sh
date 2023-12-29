echo "============================================================="
echo "|||||||||||||||||||  NETWORK IS STARTING  |||||||||||||||||||"
echo "============================================================="
./network.sh down
./network.sh up createChannel -ca -s couchdb

echo "============================================================="
echo "||  DEPLOY THE PRIVATE DATA SAMRT CONTRACT TO THE CHANNEL  ||"
echo "============================================================="
./network.sh deployCC -ccn private -ccp ../asset-transfer-private-data/chaincode-go/ -ccl go -ccep "OR('Org1MSP.peer','Org2MSP.peer')" -cccg ../asset-transfer-private-data/chaincode-go/collections_config.json

echo "============================================================="
echo "|||||||||||||||||||  REGISTER IDENTITIES  |||||||||||||||||||"
echo "============================================================="
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

echo "register a new owner client identity using the fabric-ca-client"
fabric-ca-client register --caname ca-org1 --id.name owner --id.secret ownerpw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/org1/tls-cert.pem"

echo "generate the identity certificates and MSP folder"
fabric-ca-client enroll -u https://owner:ownerpw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/tls-cert.pem"

echo "copy the Node OU configuration file into the owner identity MSP folder."
cp "${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org1.example.com/users/owner@org1.example.com/msp/config.yaml"

echo "use the Org2 CA to create the buyer identity"
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

echo "register a new owner client identity using the fabric-ca-client."
fabric-ca-client register --caname ca-org2 --id.name buyer --id.secret buyerpw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/org2/tls-cert.pem"

echo "enroll to generate the identity MSP folder"
fabric-ca-client enroll -u https://buyer:buyerpw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/tls-cert.pem"


echo "copy the Node OU configuration file into the buyer identity MSP folder."
cp "${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org2.example.com/users/buyer@org2.example.com/msp/config.yaml"

echo "============================================================"
echo "<<<<<<<<<<<<<  CREATE AN ASSET IN PRIVATE DATA  >>>>>>>>>>>>"
echo "============================================================"