CREATE TABLE "Country" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(255) NOT NULL
);

CREATE TABLE "City" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(255) NOT NULL,
  "country_id" INT
);

CREATE TABLE "User" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(255) NOT NULL,
  "city_id" INT
);

CREATE TABLE "Follow" (
  "id" SERIAL PRIMARY KEY,
  "following_id" INT,
  "follower_id" INT
);

CREATE TABLE "Hashtag" (
  "id" SERIAL PRIMARY KEY,
  "text" VARCHAR(255) NOT NULL
);

CREATE TABLE "Tweet" (
  "id" SERIAL PRIMARY KEY,
  "text" VARCHAR(255) NOT NULL,
  "author_id" INT,
  "retweet_id" INT,
  "created" TIMESTAMP,
  "image_id" INT,
  "reply_id" INT
);

CREATE TABLE "TweetHashtag" (
  "id" SERIAL PRIMARY KEY,
  "tweet_id" INT,
  "hashtag_id" INT
);

CREATE TABLE "Like" (
  "id" SERIAL PRIMARY KEY,
  "tweet_id" INT,
  "user_id" INT,
  "created" TIMESTAMP
);

CREATE TABLE "Retweet" (
  "id" SERIAL PRIMARY KEY,
  "retweeted_id" INT,
  "tweet_id" INT
);

CREATE TABLE "Image" (
  "id" SERIAL PRIMARY KEY,
  "filename" VARCHAR(255) NOT NULL,
  "path" VARCHAR(255) NOT NULL
);

CREATE TABLE "Reply" (
  "id" SERIAL PRIMARY KEY,
  "tweet_id" INT,
  "text" VARCHAR(255) NOT NULL,
  "author_id" INT
);

ALTER TABLE "City" ADD FOREIGN KEY ("country_id") REFERENCES "Country" ("id");

ALTER TABLE "User" ADD FOREIGN KEY ("city_id") REFERENCES "City" ("id");

CREATE TABLE "User_Follow" (
  "User_id" SERIAL,
  "Follow_following_id" INT,
  PRIMARY KEY ("User_id", "Follow_following_id")
);

ALTER TABLE "User_Follow" ADD FOREIGN KEY ("User_id") REFERENCES "User" ("id");

ALTER TABLE "User_Follow" ADD FOREIGN KEY ("Follow_following_id") REFERENCES "Follow" ("following_id");


CREATE TABLE "User_Follow(1)" (
  "User_id" SERIAL,
  "Follow_follower_id" INT,
  PRIMARY KEY ("User_id", "Follow_follower_id")
);

ALTER TABLE "User_Follow(1)" ADD FOREIGN KEY ("User_id") REFERENCES "User" ("id");

ALTER TABLE "User_Follow(1)" ADD FOREIGN KEY ("Follow_follower_id") REFERENCES "Follow" ("follower_id");


ALTER TABLE "Tweet" ADD FOREIGN KEY ("author_id") REFERENCES "User" ("id");

ALTER TABLE "Tweet" ADD FOREIGN KEY ("retweet_id") REFERENCES "Tweet" ("id");

ALTER TABLE "Tweet" ADD FOREIGN KEY ("image_id") REFERENCES "Image" ("id");

ALTER TABLE "Tweet" ADD FOREIGN KEY ("reply_id") REFERENCES "Reply" ("id");

CREATE TABLE "Tweet_TweetHashtag" (
  "Tweet_id" SERIAL,
  "TweetHashtag_tweet_id" INT,
  PRIMARY KEY ("Tweet_id", "TweetHashtag_tweet_id")
);

ALTER TABLE "Tweet_TweetHashtag" ADD FOREIGN KEY ("Tweet_id") REFERENCES "Tweet" ("id");

ALTER TABLE "Tweet_TweetHashtag" ADD FOREIGN KEY ("TweetHashtag_tweet_id") REFERENCES "TweetHashtag" ("tweet_id");


CREATE TABLE "Hashtag_TweetHashtag" (
  "Hashtag_id" SERIAL,
  "TweetHashtag_hashtag_id" INT,
  PRIMARY KEY ("Hashtag_id", "TweetHashtag_hashtag_id")
);

ALTER TABLE "Hashtag_TweetHashtag" ADD FOREIGN KEY ("Hashtag_id") REFERENCES "Hashtag" ("id");

ALTER TABLE "Hashtag_TweetHashtag" ADD FOREIGN KEY ("TweetHashtag_hashtag_id") REFERENCES "TweetHashtag" ("hashtag_id");


ALTER TABLE "Like" ADD FOREIGN KEY ("tweet_id") REFERENCES "Tweet" ("id");

ALTER TABLE "Like" ADD FOREIGN KEY ("user_id") REFERENCES "User" ("id");

ALTER TABLE "Retweet" ADD FOREIGN KEY ("retweeted_id") REFERENCES "Tweet" ("id");

ALTER TABLE "Retweet" ADD FOREIGN KEY ("tweet_id") REFERENCES "Tweet" ("id");

ALTER TABLE "Reply" ADD FOREIGN KEY ("tweet_id") REFERENCES "Tweet" ("id");

ALTER TABLE "Reply" ADD FOREIGN KEY ("author_id") REFERENCES "User" ("id");
