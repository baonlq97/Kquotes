# Minimal Quotes
The app follows MVVMC clean architecture for ease of development in the future. The application concept and the design are created by Kishore from Elitepixels as a part of [Project365](https://project365.design/2018/05/07/day-127-minimal-quotes-app-concept/)

"Minimal Quotes" is an iOS application that throws you random quotes in a super clean minimal version.
Some of the app functions:
- Throw you a random quote when you restart the app || when you press `tap for more`
- Add quotes to the favorite and re-read them whenever you like to
- Choose a category that you like to receive a new quote
- Schedule a time and a `Quote of the day` will be sent to you every day via notification
  - **Note: Due to Apple's policy, it's not guaranteed that the notification will push at the specific scheduled time, there will be a delay (a lot). Furthermore, it only works when the app is in background mode, clear the app from recent will kill the app completely**
- Lastly, share it to your social!

![Big Beautiful Picture](https://i.imgur.com/aQRCj7c.png)

# Try it yourself
You need to create your account at [`api-ninjas`](https://api-ninjas.com/) and get the API key from it
- Pull this project
- Create Key.plist file in the Resource Group
- Add these properties:
  - QuoteBaseURL: ninja-api end point
  - QuoteAPIKey: Your API key after finishing creating the account
- Now start the app. :)
