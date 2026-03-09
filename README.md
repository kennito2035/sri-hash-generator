# SRI Hash Generator v1.0.0

A lightweight Windows batch utility that downloads a file from a URL and outputs its **SHA-256**, **SHA-384**, and **SHA-512** [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) hashes — ready to paste directly into a `<script>` or `<link>` tag.

---

## Requirements

| Dependency | Notes |
|---|---|
| Windows 10 or later | Required for ANSI color support |
| `curl` | Included in Windows 10 build 1803+ |
| PowerShell | Included in Windows |

No installs. No dependencies. No admin rights needed.

---

## Usage

1. Double-click `sri-hash-generator.bat`
2. Paste a file URL when prompted (e.g. a CDN link to a `.js` or `.css` file)
3. Press Enter
4. Copy the hash(es) you need

**Example output:**
```
sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=
sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC
sha512-z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg/SpIdNs6c5H0NE8XYXysP+TGr7pUpr4s4h3wr/cyGvzNMtbBbBsw==
```

---

## Using SRI Hashes in HTML

Paste the hash into the `integrity` attribute of a `<script>` or `<link>` tag:

```html
<!-- JavaScript -->
<script
  src="https://cdn.example.com/library.min.js"
  integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC"
  crossorigin="anonymous">
</script>

<!-- CSS -->
<link
  rel="stylesheet"
  href="https://cdn.example.com/styles.min.css"
  integrity="sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU="
  crossorigin="anonymous"
/>
```

> **Which algorithm should I use?**  
> `sha384` is the most widely recommended. `sha512` is the strongest. `sha256` is broadly supported but the weakest of the three. All three are output so you can choose.

---

## How It Works

1. `curl` downloads the file to a temporary `sri.tmp`
2. PowerShell's `Get-FileHash` computes the hex digest for each algorithm
3. The hex is converted to a byte array and base64-encoded
4. Results are printed and `sri.tmp` is deleted

No data is sent anywhere beyond the initial download request.

---

## Troubleshooting

**"Download failed"**  
- Check the URL is publicly accessible and correct
- If behind a proxy, set `HTTPS_PROXY` in your environment before running

**Colors not showing**  
- Requires Windows 10 build 1511 or later with a terminal that supports ANSI (Command Prompt, Windows Terminal, PowerShell)

**Hash doesn't match another tool**  
- Make sure you're hashing the exact same file. Even a single byte difference (e.g. a CDN serving different content per region) will produce a different hash.