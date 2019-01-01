![Firestorm](./assets/images/firestorm-logo.png)

### An open-source forum engine, with an Elixir+Phoenix backend and an Elm frontend.

#### A community-funded project from [DailyDrip](https://www.dailydrip.com).

This is the Elixir backend for the [Firestorm Forum
project](https://github.com/dailydrip/firestorm). This is a bit of a rewrite to make it a bit better
factored long term. It's presently at version 2.0-alpha-1. It needs a bit of work to consider it
proper 2.0, but it's presently supporting the comments on
[SmoothTerminal](https://www.smoothterminal.com) in production.

There were two primary motivations for a rewrite.

- To properly decouple the data layer from the web interface. This was a feature of early releases
  of Firestorm 1.0, but in the process of building it for tutorials it was dropped for ease of
  explanation. Sadly, this led to it being improperly coupled and this was never fixed. Now the data
  layer may be used standalone to bring a forum into an existing application trivially.
- To switch to GraphQL for the API. When building the first version, GraphQL had a problematic
  license. Facebook has since rectified that situation, so we rebuilt it focusing on providing a
  GraphQL API.

## Patrons

This project was funded by [a
Kickstarter](https://www.kickstarter.com/projects/1003377429/firestorm-an-open-source-forum-in-phoenix-from-eli).

All of the patrons that made it possible are listed in [the PATRONS
file](https://github.com/dailydrip/firestorm/blob/master/PATRONS.md) in the main project.

## License

Firestorm is [MIT Licensed](./LICENSE).
