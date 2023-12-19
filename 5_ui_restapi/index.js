const proxyurl = "https://cors-anywhere.herokuapp.com/";

async function createAsset() {
    /*const response = */await fetch(proxyurl + 'http://localhost:3000/invoke', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: new URLSearchParams({
        channelid: document.getElementById('channelID').value,
        chaincodeid: document.getElementById('chaincodeID').value,
        function: createAsset,
        args: [
            document.getElementById('assetID').value,
            document.getElementById('color').value,
            document.getElementById('size').value,
            document.getElementById('owner').value,
            document.getElementById('appraisedValue').value
        ]
    })
})
        .then(response => response.json())
        .then(data => {
            console.log('Create Asset Response:', data);
            // Update UI or handle response data here
        })
        .catch(error => {
            console.error('Error creating asset:', error);
            // Handle error scenario
        });
    // console.log(response);
    // document.getElementById('createResult').value = await response.text();
}

async function getAllAssets() {
    const response = await fetch('http://localhost:3000/query?channelid=mychannel&chaincodeid=basic&function=GelAllAssets');
    console.log(response);
    document.getElementById('getAllResult').value = await response.text();
}

async function countAllAssets() {
    const response = await fetch('http://localhost:3000/query?channelid=mychannel&chaincodeid=basic&function=CountAllAssets');
    console.log(response);
    document.getElementById('countResult').value = await response.text();
}