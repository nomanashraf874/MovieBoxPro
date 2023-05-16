# MovieBoxPro
Movie Box is a social movie recommendation app designed to enhance your movie-watching experience. Discover personalized movie recommendations based on your interactions within the app, including survey, comments, likes, and following. Connect with fellow movie enthusiasts and explore a community of users who share your passion for films. Enjoy a tailored recommendation system and engage in social interactions that revolve around the love of movies!

![fin](https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/4874a622-873c-4aec-822b-e0ea51f9d40d)

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
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/7a93dc55-323f-40be-8a5e-4dea0e12d595

## Register
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/24f9113e-2afd-4b9b-8a61-ac69c0b8fcae

## Login
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/6a2a1e0b-7997-4cfa-b982-f0c3725481be

## Survey
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/e040aa4b-4c63-4b61-82ed-ae6edd827dad

## Recommendations
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/b12961c4-c12c-498f-bac2-cf50432e05e5

## Search
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/52408e08-d587-418f-933e-4b586570e117

## Explore
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/a5b4cab5-223d-4b93-9a9a-59a26291cec2

## Movie Details
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/e6a5351b-1667-4cdf-9a91-27a79c86433d

## Comment
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/0bde0bb0-3b09-425d-a473-6c2fa85e7986

## Like
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/b7204f48-a451-4b17-9a50-21a4ae878952

## Trailer
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/2a63dadf-6374-42f3-b453-e225a87d4993

## Follow
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/d02491d2-f3e8-491a-a104-cbf39ac378f0

## Profile and Logout
https://github.com/nomanashraf874/MovieBoxPro/assets/73111863/fca87414-0a93-47f1-9e6f-24d5fe771998
