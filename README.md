# matrix-turn
A STUN/TURN server, optimized for setup with [Matrix](https://matrix.org) home servers.

**NOTE:** We're using the external 'host' network instead of publishing ports.
This is required to work around the no-NAT requirement for coturn, even though it destroys network isolation for the container.

## docker run
```bash
docker run -it \
    --name coturn \
    -e COTURN_SECRET=mysecret \
    -e COTURN_REALM=turn.example.com \
    --net=host \
    johnstarich/matrix-turn:1.0.0
```

## docker stack

```yaml
version: "3.4"

services:
  coturn:
    image: johnstarich/matrix-turn:1.0.0
    environment:
    - COTURN_SECRET=mysecret
    - COTURN_REALM=turn.example.com
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
* `COTURN_SECRET` - `turn_shared_secret:` in Matrix config
* `COTURN_REALM` - public hostname for the TURN server, `turn_uris:` in Matrix config
    - Example Matrix config line: `turn_uris: ["turn:turn.example.com?transport=udp", "turn:turn.example.com?transport=tcp"]`
	
If you need to do some debugging, set `VERBOSE=true` as well.

See [`entrypoint.sh`](./entrypoint.sh) for all available environment variables.


## coturn license
See [coturn's license](https://github.com/coturn/coturn/blob/master/LICENSE) for more info.
