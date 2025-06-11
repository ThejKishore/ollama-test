# ollama-test


```bash
./splitter.sh split
./splitter.sh verify
./splitter.sh combine
```

✅ To Recombine Later
On the target machine or when needed:

```bash
cat ollama_chunk_* > ollama-with-mistrallite.tar
```

You can then load it into Docker:

```bash
docker load -i ollama-with-mistrallite.tar
```
