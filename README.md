## An iOS Twitter Redux app

Time spent: 14 hr

## Steps to run

- Open the project with Xcode and add your Twitter keys at the TwitterClient.m.

## Features
- [X] Hamburger menu
  - [X] Dragging anywhere in the view should reveal the menu.
  - [X] The menu should include links to your profile, the home timeline, and the mentions view.
  - [X] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.
- [X] Home Timeline
  - [X] Tapping on a user image should bring up that user's profile page
- [X] Profile page
  - [X] Contains the user header view
  - [X] Contains a section with the users basic stats: # tweets, # following, # followers
  - [X] Optional: Implement the paging view for the user tweets and favorites.
  - [X] Optional: Pulling down the profile page should blur and resize the header image.
- [X] Additional: Implement the image viewer when user tap timeline tweet image.
- [X] Additional: A screen shake effect will show if the user tap profile image that is the same as the current profile user like the real twitter ios app.
  
### Walkthrough

![Video Walkthrough](Demo1.gif)  
  
<br />
***

This is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: 18 hr

## Features

### Required

- [X] User can sign in using OAuth login flow
- [X] User can view last 20 tweets from their home timeline
- [X] The current signed in user will be persisted across restarts
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [X] User can pull to refresh
- [X] User can compose a new tweet by tapping on a compose button.
- [X] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

### Optional

- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [X] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [X] User can compose a new tweet with current geo location.

### Walkthrough

![Video Walkthrough](Demo.gif)

Credits
---------
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [DateTools](https://github.com/MatthewYork/DateTools)
* [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
* [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)
* [JVFloatingDrawer](https://github.com/JVillella/JVFloatingDrawer)

