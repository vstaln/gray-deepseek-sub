<div align="center">
  <img alt="gray-deepseek-sub" src="assets/icon.svg" width="120" height="120" />
  <h1>gray-deepseek-sub</h1>
  <p><strong>DeepSeek's chat and reasoner models as a gray provider.</strong></p>
  <p>
    <a href="https://gray.alignment.id">Website</a> ·
    <a href="https://github.com/vstaln/gray-deepseek-sub">Source</a> ·
    <a href="https://github.com/vstaln/gray">gray</a>
  </p>
  <p>
    <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-1c1c20?style=flat-square&labelColor=0a0a0b" /></a>
    <a href="https://www.rust-lang.org"><img alt="Built with Rust" src="https://img.shields.io/badge/built%20with-rust-1c1c20?style=flat-square&labelColor=0a0a0b&logo=rust&logoColor=d4a373" /></a>
    <img alt="gray plugin" src="https://img.shields.io/badge/gray-plugin-1c1c20?style=flat-square&labelColor=0a0a0b&color=7aa2f7" />
  </p>
</div>

<br/>
```bash
gray plugin install deepseek
```

`gray-deepseek-sub` is a provider sidecar for [gray](https://github.com/vstaln/gray).
The host speaks the OpenAI Responses wire shape to a per-turn loopback
relay this plugin mints; the plugin translates each turn into
DeepSeek's OpenAI-compatible `https://api.deepseek.com/chat/completions` upstream.

That means streaming text, tool calls, and usage accounting all behave
like a first-class gray provider — while the wire stays one-shot and
stateless on the upstream side.

## Requirements

Requires a DeepSeek API key from <https://platform.deepseek.com>.

Set `DEEPSEEK_API_KEY` or run `{bin} setup --key sk-…`.

## Setup

```sh
deepseek-sub status          # shows configured/upstream state
deepseek-sub models          # live model list from the upstream
deepseek-sub setup --key …   # write ~/.gray/deepseek/config.json (0600)
```

Configuration resolves env-first, then `~/.gray/deepseek/config.json`:

| Setting | Env | Config key | Default |
|---|---|---|---|
| base URL | `DEEPSEEK_BASE_URL` | `base_url` | `https://api.deepseek.com/v1` |
| API key | `DEEPSEEK_API_KEY` | `api_key` | — |

## In gray

Select the provider by name (`deepseek`) with the `api_key`-style auth
method where required; the plugin reports models, auth state, and errors
through the normal provider ops (`provider/models`, `provider/chat`,
`provider/auth/*`).

## How it works

- `provider/chat` mints a **request-scoped loopback relay** (one response
  per turn) and returns its URL to the host.
- The host POSTs a Responses-shaped request; the plugin translates
  messages/tools/images into the OpenAI chat-completions shape, calls the
  upstream, and folds the result back into a Responses SSE stream
  (`response.created` → deltas → `response.completed` → `[DONE]`).
- Credentials travel in the provider `CredentialEnvelope`; secrets are
  never logged (relay URLs and tokens are redacted in debug output).

## Build from source

```sh
cargo build --release
gray plugin check ./target/release/deepseek-sub
```

## License

MIT
