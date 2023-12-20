const proxyurl = "https://cors-anywhere.herokuapp.com/";

async function createAsset() {
    const response = await fetch(proxyurl + 'http://localhost:3000/invoke', {
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
    .then(response => response.text())
    .then(data => {
        console.log('Create Asset Response:', data);
        document.getElementById('createResult').value = data;
        // Update UI or handle response data here
    })
    .catch(error => {
        console.error('Error creating asset:', error);
        // Handle error scenario
    });
}

const getAllAssets = () => {
    fetch("http://localhost:3000/query?channelid=mychannel&chaincodeid=basic&function=GetAllAssets")
        .then((response) => {
            return response.text();
        })
        .then((data) => {
            console.log(data);
            document.getElementById('get-all-assets-response').value = data;
        });
}


async function countAllAssets() {
    fetch("http://localhost:3000/query?channelid=mychannel&chaincodeid=basic&function=CountAllAssets")
        .then((response) => {
            return response.text();
        })
        .then((data) => {
            console.log(data);
            document.getElementById("count-all-assets-response").value = data
        })
}


