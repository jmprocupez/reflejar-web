# Reflejar — Catálogo Web

Sitio de una página para el catálogo de productos de Reflejar S.A.

## Estructura

```
reflejar-web/
├── index.html       ← toda la página (HTML + CSS + JS embebido)
├── reflejar-logo.svg
├── vercel.json
└── README.md
```

## Deploy en Vercel

1. Abrir terminal en esta carpeta: `cd reflejar-web`
2. Inicializar git: `git init && git add . && git commit -m "init"`
3. Crear repositorio en GitHub y pushear
4. Ir a vercel.com → New Project → importar ese repo
5. Vercel lo detecta como sitio estático automáticamente

## Personalización futura

- **Fotos propias**: reemplazar las URLs de Unsplash en `index.html` (buscar `unsplash.com`) por fotos reales de los productos de Reflejar.
- **WhatsApp**: el número actual es `+54 11 4581-0618`. Actualizarlo si Reflejar tiene un número de WhatsApp específico.
- **Dominio**: conectar dominio propio desde el panel de Vercel → Settings → Domains.
