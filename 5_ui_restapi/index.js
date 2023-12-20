const createAsset = () => {
    fetch('http://localhost:3000/invoke', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams({
            channelid: "mychannel",
            chaincodeid: "basic",
            function: "createAsset",
            // args: `${document.getElementById('assetid').value} ${document.getElementById('assetcolor').value} ${document.getElementById('assetsize').value} ${document.getElementById('assetowner').value} ${document.getElementById('assetappraisedvalue').value}`,
            args: [
                document.getElementById('assetid').value,
                document.getElementById('assetcolor').value,
                document.getElementById('assetsize').value,
                document.getElementById('assetowner').value,
                document.getElementById('assetappraisedvalue').value,
            ]
            // args: document.getElementById('assetid').value,
            // args: document.getElementById('assetcolor').value,
            // args: document.getElementById('assetsize').value,
            // args: document.getElementById('assetowner').value,
            // args: document.getElementById('assetappraisedvalue').value,
        }),
    })
        .then((response) => {
            return response.json();
        })
        .then((data) => {
            console.log('Create Asset Response:', data);
            document.getElementById('create-asset-response').value = data;
        })
    // .catch(error => {
    //     console.error('Error creating asset:', error);
    //     // document.getElementById('create-asset-response').value = `Error:: ${error}`;
    // });
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


const countAllAssets = () => {
    fetch("http://localhost:3000/query?channelid=mychannel&chaincodeid=basic&function=CountAllAssets")
        .then((response) => {
            return response.text();
        })
        .then((data) => {
            console.log(data);
            document.getElementById("count-all-assets-response").value = data
        })
}


