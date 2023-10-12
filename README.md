# Run ads services
Ads project created for receiving telegram bot notifications about current advertisements from websites, with a slight delay after their publication.

## Run Project
1. Set ```.env``` file
2. Use ```docker compose up -d``` to build and run docker containers with application itself

### Example environment file ```.env```:

```
HOST_URL=<url>
TELEGRAM_BOT_TOKEN=<token>
TELEGRAM_FEEDBACK_CHAT_ID=<chat_id>
GF_SERVER_DOMAIN=<domain>
```
