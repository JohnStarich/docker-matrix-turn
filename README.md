# matrix-turn
A STUN/TURN server, optimized for setup with [Matrix](https://matrix.org) home servers.
Uses an [env-based config][e2c].

[e2c]: https://github.com/JohnStarich/env2config

**NOTE:** We're using the external 'host' network instead of publishing ports.
This is required to work around the no-NAT requirement for coturn, even though it destroys network isolation for the container.

## docker run
```bash
docker run -it --rm \
    --name coturn \
    -e SHARED_SECRET=mysecret \
    -e REALM=turn.example.com \
    --net=host \
    johnstarich/matrix-turn:2.0.0
```

## docker stack

```yaml
version: "3.4"

services:
  coturn:
    image: johnstarich/matrix-turn:2.0.0
    environment:
    - SHARED_SECRET=mysecret
    - REALM=turn.example.com
    # Optional:
    #- INTERNAL_IP=
    #- EXTERNAL_IP=
    #
    # NOTE: We're using the external 'host' network instead of publishing ports.
    # This is required to work around the no-NAT requirement for coturn, even though it destroys network isolation for this container.
    networks:
    - host

networks:
  host:
    external: true
```

### Environment variables
These environment variables are required:
* `SHARED_SECRET` - `turn_shared_secret:` in Matrix config
* `REALM` - public hostname for the TURN server, `turn_uris:` in Matrix config
    - Example Matrix config line: `turn_uris: ["turn:turn.example.com?transport=udp", "turn:turn.example.com?transport=tcp"]`
	
If you need to do some debugging, add `-e COTURN_verbose=` (blank value) as well.

See [coturn][] for all available config values, then set them as environment variables with `COTURN_` prefixes.

[coturn]: https://github.com/coturn/coturn

## coturn license
See [coturn's license](https://github.com/coturn/coturn/blob/master/LICENSE) for more info.
