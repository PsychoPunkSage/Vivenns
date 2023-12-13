# Nginx Reverse Proxy

> 1. Creating a basic REST API (use any language; here I used Node.js).
> 2. Convert the REST API to Docker Image form. 
> 3. Run the docker image to check it it is working or not.

```bash
docker run --rm -d -p 3001:3001/tcp {NAME_OF_API}:{TAG}
```
By default TAG = latest


## Connecting with Nginx

#### Run the docker image of Nginx

```bash
docker run -rm -d -p 81:80 --name {IMAGE_NAME} nginx
```

#### Need to change the **default.conf** file inside the Nginx Image..
```bash
docker cp nginx-base:/etc/nginx/conf.d/default.conf {LOCATION_TO_BE_COPIED}
```

#### Open **default.conf** file and do the given changes **ONLY** (see the **default.conf.example**)
```
location /rest {
  rewrite ^/rest http://localhost:3001/ break;
  proxy_pass http://localhost:3001/;
}
```
> The **rewrite** directive catches any request starting with /rest and replaces it with just http://localhost:{PORT_NUMBER}/, effectively removing the "/rest" prefix.

> The **proxy_pass** directive then forwards the rewritten request to the actual API root.

#### Run the following commands to configure
```bash
docker cp {UPDATED default.conf PARENT location}/default.conf proxy:/etc/nginx/conf.d/

docker exec proxy nginx -t

docker exec proxy nginx -s reload

sudo service nginx restart
```
>OR 
<br>
I have writen a bash script i.e. **configure.sh** to automate the process.
<br>How to use configure.sh?<br>
Ans.: Make Necessary changes specified inside <{}>

```bash
chmod 777 configure.sh
./configure.sh
```

> Now Visit **http://localhost:81/rest**. You can see the API.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)