# CI Tools

See [docker/scripts/install-tools.sh] for a list of what is included in this image.

## Usage

```bash
docker run --rm -ti jc21/ci-tools <your commands>

# ie:
docker run --rm -v "$(pwd):/data" jc21/ci-tools php -v
```
