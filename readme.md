# My Movie App

## Getting Started

### Docker secrets

For development generate the secrets that docker-compose will use to to pass database credentails for our development environment.

```
mkdir secrets
openssl rand 20 | base64 -w 0 > ./secrets/MYSQL_ROOT_PASSWORD
openssl rand 20 | base64 -w 0 > ./secrets/MYSQL_PASSWORD
echo "mydbuser" > ./secrets/MYSQL_USER
```

### Environment variables

Create a `.env` file for your envrionment.

```
cp .env.example .env
```

### OMDB API

This application uses the Open Movie Database API. You can register for a free API key at https://www.omdbapi.com/.

Set `OMDB_API_KEY=<yourkeyhere>` in the .env file.

### Run the application using Docker Compose.

```
docker compose up
```

### VS Code - Remote Container

You can also run the application using the VS code remote container extension. 