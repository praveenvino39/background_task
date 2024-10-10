In the project folder, you will find `node_server`, which is responsible for sending silent push notifications.

Current only tested on Android:

- Copy `google-services.json` into `android/app/`
- Copy `admin.json` into `node_server/`

- **Endpoint: `/send-silent-push`**  
  This endpoint requires two parameters:
  1. **Device token**: You can obtain this by running the application and checking the debug log.
  2. **Data**: A key-value pair (`<string, string>`) where you can send any custom string.

When the app receives the silent push notification, it will trigger the `backgroundHandler` function in the `main.dart` file, allowing you to perform any task.

### Current Task:

The app currently sends a request to the JSONPlaceholder API using the `id` received from the server, and stores the response in the local storage. The next time the user opens the app, the saved response will be displayed on the screen.

```
    curl --location 'localhost:3000/send-silent-push' \
    --header 'Content-Type: application/json' \
    --data '{
        "deviceToken": "<REPLACE_DEVICE_TOKEN_HERE>",
        "data": {
            "id": "1"
        }
    }'
```
