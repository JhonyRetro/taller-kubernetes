# PokeProxyApi

API en .NET que replica la superficie de `https://pokeapi.co/api/v2` y reenvía las peticiones a la PokeAPI real.

## Requisitos

- .NET SDK 8.0

## Ejecutar

```bash
cd poke-app/back
dotnet restore
dotnet run
```

La API quedará expuesta por defecto en:

```text
http://localhost:5180
```

## Endpoints

- `GET /health`
- `GET /api/v2/{endpoint}`
- `GET /api/v2/{endpoint}/{id-o-name}`
- `GET /api/v2/{endpoint}?limit=20&offset=20`

## Ejemplos

```bash
curl http://localhost:5180/api/v2/pokemon/pikachu
curl http://localhost:5180/api/v2/pokemon?limit=10&offset=20
curl http://localhost:5180/api/v2/ability/1
curl http://localhost:5180/api/v2/type/fire
```

## Notas

- El backend no implementa lógica Pokémon propia; actúa como proxy HTTP.
- Las respuestas, códigos de estado y errores vienen de la PokeAPI real.
- La documentación oficial de referencia es: https://pokeapi.co/docs/v2
