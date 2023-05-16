# MovieBoxPro
Movie Box is a social movie recommendation app designed to enhance your movie-watching experience. Discover personalized movie recommendations based on your interactions within the app, including survey, comments, likes, and following. Connect with fellow movie enthusiasts and explore a community of users who share your passion for films. Enjoy a tailored recommendation system and engage in social interactions that revolve around the love of movies!

![fin](https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/2ecc096d-5e8e-46df-9a6d-c9ae051705de)

## User Stories
- [x] User can Register
- [x] User can Login.
- [x] User can Logout.
- [x] Survey for user preferences
- [x] Personalized recomendations based on User Interaction(survey, comments, likes, and following)
- [x] View movie Details(synopsis, rating, poster, related movies, trailer and etc)
- [x] Like a movie
- [x] Comment under a movie
- [x] Search for movies
- [x] Explore movies (popular, now playing and Upcoming)
- [x] View User Profile (following count, Like count, Username, profile pic, liked movies , user comments and selected generes)
- [x] User can view other users profile
- [x] User can follow other users

## Recomendation System 
The movie recommendation algorithm in this project is designed to provide personalized recommendations based on genre preferences. User preferences within each genre are determined through an equal distribution of four factors:

Initial Survey: The user's response to the initial survey indicates their initial inclination towards specific genres.

Likes: The percentage of movies liked by the user within each genre influences their preference for those genres.

User Comments: The percentage of comments made by the user within each genre reflects their engagement and interest.

Following: The percentage of users the individual follows who have a preference for a particular genre helps identify commonly appreciated genres.

By analyzing these factors, the algorithm assigns a rating to each genre, determining its relevance to the user's preferences. The top four genres with the highest ratings are then selected as the user's genre preferences, forming the basis of the personalized movie recommendations. 

## Database Schema
Database Schema:

- Email
  - email
    - username: String
    - friends: [String]
    - liked: [String]
    - preferences: [String]
    - initialized: [String]
    - commented: [String]
    - likeCount: Int
    - commentCount: Int
    - User Preferences:
      - genre
        - likes: Int
        - commented: Int
        - initial: Bool
      ...(Additional genres)

- Comments
  - Movie 1
    - comment: [Comment]

## Welcome screen
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/2c0574a4-a5b6-4107-89af-b20847a4d932

## Register
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/f34974e3-a088-4577-a392-a174ce55b0dc

## Login
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/7ae830ed-fbbf-447b-a7ab-900df806b36b

## Survey
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/a8e177ee-30a1-4dce-91fc-8a600796bf4b

## Recommendations
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/b0889c9e-8b15-47aa-9b72-49114d379e14

## Search
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/adaebab7-e561-41c6-917c-041b117da04d

## Explore
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/a4fb3f5f-31aa-428d-ae9e-222c09e048d9

## Movie Details
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/80cd7e82-9146-477c-aeb7-bfe8f2a015f6

## Comment
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/0d226404-c19d-40f5-81d0-55964f631ac9

## Like
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/0fc9101a-00fc-46d1-b202-9ae126a80f5a

## Trailer
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/ccf455b4-5cac-42f8-bdfb-e7f055342d33

## Follow
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/011beb6c-b180-4905-8ce8-08e3798b2dcc

## Profile and Logout
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/ae7e0b04-9cf0-4dfd-a2a3-7e2e810192f1
