# Poke App Front

Frontend en React + Vite que consume el backend .NET de `poke-app/back`.

## Requisitos

- Node.js 18 o superior
- Backend .NET levantado en `http://localhost:5180`

## Ejecutar

```bash
cd poke-app/front
npm install
npm run dev
```

## Configuración

Puedes cambiar la URL base del backend con una variable de entorno:

```bash
VITE_API_BASE_URL=http://localhost:5180/api/v2
```

## Funcionalidades

- Listado paginado de Pokémon
- Búsqueda por nombre
- Tarjetas con imagen oficial
- Gestión de estados de carga y error
