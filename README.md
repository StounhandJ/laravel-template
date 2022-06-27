## Dependencies:
1. [Docker](https://www.docker.com/)
1. [docker-compose](https://github.com/docker/compose)
1. DNS [Cloudflare](https://www.cloudflare.com/)
## Launch:
1. Connect your website to cloudflare. 
2. In the file [.env](.env) write:  
2.1. Your domain to the DOMAIN variable  
2.2. Site name APP_NAME  
2.3. Mail linked to cloudflare CLOUDFLARE_EMAIL get [here](https://dash.cloudflare.com/profile)  
2.4. Cloudflare Global api key CLOUDFLARE_API_KEY get [here](https://dash.cloudflare.com/profile/api-tokens)  
2.5. (Additionally) According to the smtp connection standard, configure these variables MAIL_PORT MAIL_HOST MAIL_USERNAME MAIL_PASSWORD MAIL_FROM_ADDRESS  
2.6. (Additionally) Administrator's email APP_MAIL  
3. `chmod +x run.sh` Grant rights to execute the script
4. `./run.sh` Run the project

### Example of SSL/TLS configuration
![](documentation/cloudflare.png) 
****
## Additional:
To restart the project and get new updates, write `./restart.sh`.  
