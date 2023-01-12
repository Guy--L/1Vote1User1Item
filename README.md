Please run `redis-server` 
before `rails s`
   
   
---

## Introduction

[Hacker News](https://news.ycombinator.com/) is a well-known technology news aggregator service and forum maintained by seed stage investment firm, Y-Combinator. Via Firebase, Y-Combinator provides a simple JSON API to retrieve story information. The API requires no authentication and is documented in a [GitHub repo](https://github.com/HackerNews/API). The two most useful API calls are:

* [List of top stories](https://hacker-news.firebaseio.com/v0/topstories.json)
* [Show story details](https://hacker-news.firebaseio.com/v0/item/8863.json)

Suppose you have a small team of developers who all regularly browse Hacker News for industry insights. This team would like a simple way to flag articles that could be of interest to other team members and publish that list out to the rest of the team. This UI would be deployed for internal use so it would not require a public sign up but would be pre-populated with users who will be team members.

When a team member signs in, they will see recent news stories and be able to star, flag, highlight, or otherwise mark a story as interesting. A separate list should display all the stories that were deemed interesting and the name of the person who marked it so.

## Requirements

* Users should sign in.
* Users should come to a page and see a list of current top Hacker News stories.
* This list does not necessarily need to be the current live list, but it should be a recent and continuously updated list.
* The user should be able to vote for a story. 
* The stories chosen by the team members should display.
* Each story should show the name of the team member or members who flagged it.

---

## Architecture Notes

### Renaming

> Story => Item  
> Star => Vote

### Initialize

by syncing up with NewsClient::ids.each { |id| save NewsClient::item(id) }  
preferably asynchronous (loading n of N items should be easy since all ids are retrieved first)

### Navbar

- Session
- Button: Countdown until HY Refeed (click to Refeed now)
- Stats: Users Votes Items AgedOff

### Item Controller

- index method serves html list items
- vote for Item, then broadcast others (after user clicks + next to vote count)
- unvote for item, then broadcast others (after user clicks - next to vote count)

### Turbo Stream (**AC**)

- update item row with vote from others
  - item id, user id, name
- add item from Refeed/Refresh button
  - new item from Refeed adds item id to cache/db, attaches user id via Stimulus

### Refresh (on top of NewsClient)

    new items =
    NewsClient:ids
        .filter(where id not in cache/db)
        .each { |id| NewsClient:item(id) }

### Feed Window/Item Retention Policy

1.  Retain locally all items forever
2.  Current Top Item Match (losing old votes)
3.  Retain only those with a vote
4.  Retain within time window (cache policy)

### List in browser

Row contains (styled to match HN)

1.  Item details
2.  "apply" or "rescind" vote link
3.  Vote count before Author
4.  Voter names listed after vote link

Sort on (vote count | item retrieved) descending