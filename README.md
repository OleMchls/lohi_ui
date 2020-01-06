# Lohi - An RFID based cassette recorder
But without cassette and recording, but with loads of fun for big and small kids.

![ENSsRLQWwAEgTYn](https://user-images.githubusercontent.com/584259/71844899-2f4c2080-3095-11ea-818f-5480b69579f9.jpeg)

If you have not seen the main project repository [Lohi](https://github.com/OleMchls/lohi) make sure to visit that repo first to familiarize yourself with the idea of the project: https://github.com/OleMchls/lohi.

## Getting Started
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Deploying assets with lohi
First, build the assets in the `assets` folder: `npm run deploy`
Next, generate assets digests from project root: `mix phx.digest`
