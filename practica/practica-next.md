# Práctica: despliegue de una aplicación web en Kubernetes con Minikube y Argo CD

## Objetivo

Desarrolla y despliega una aplicación web sencilla (frontal base con hello world) sobre Kubernetes usando Minikube, y GitOps con Argo CD.

La práctica debe demostrar que eres capaz de:

- versionar una aplicación y su infraestructura en GitHub;
- dockerizar una aplicación web;
- definir manifiestos de Kubernetes;
- configurar probes de salud de readiness y liveness;
- desplegar la aplicación en Minikube;
- creación de la application con Argo CD.

## Idea principal de la práctica

Lo más importante de esta práctica es que el repositorio tenga una estructura clara y coherente, y que los archivos entregados tengan sentido entre sí.

Se valorará especialmente:

- una organización lógica de carpetas y archivos;
- nombres claros y consistentes;
- manifiestos de Kubernetes bien separados por responsabilidad;
- documentación suficiente para entender cómo está montada la solución;
- coherencia entre imágenes Docker, `Deployment`, `Service`, `Ingress`, secretos y configuración de Argo CD.

Si el ejemplo no llega a funcionar completamente, la práctica puede considerarse válida siempre que la estructura del proyecto, los manifiestos y los archivos entregados sean lógicos, consistentes y estén bien organizados.

## Requisitos de la práctica

Debes construir una solución completa que incluya, como mínimo, los siguientes elementos:

### 1. Aplicación y control de versiones

- Mantén el código fuente y la configuración de infraestructura versionados en GitHub.
- Organiza el repositorio de forma clara para separar, si procede, la aplicación, los manifiestos y la documentación.

Como guía, una estructura razonable podría ser:

```text
repo/
├── README.md
├── practica/
├── scripts/
├── argocd/
│   ├── application/
│   │   └── upm.yaml
│   └── repo/
│       ├── repo-upm-secret-ssh.yaml
│       └── repo-upm-secret-https.yaml
└── poke-app/
    ├── front/
    ├── back/
    ├── auth/
    └── k8s/
        ├── namespace/
        ├── front/
        ├── back/
        ├── auth/
        ├── auth-db/
        ├── ingress/
        ├── secret/
        └── kustomization.yaml
```

No es obligatorio replicar exactamente esta estructura, pero sí mantener una separación clara entre:

- código de la aplicación;
- manifiestos de Kubernetes;
- configuración de Argo CD;
- scripts auxiliares;
- documentación.

### 2. Contenerización

- Crea la imagen Docker de la aplicación.
- Define un `Dockerfile` coherente con el tipo de aplicación elegida.

Si tu solución tiene varios componentes, es razonable que cada uno tenga su propio `Dockerfile`, por ejemplo:

- `front/Dockerfile`
- `back/Dockerfile`
- `auth/Dockerfile`

### 3. Despliegue declarativo en Kubernetes

- Define los manifiestos necesarios para desplegar la aplicación en Kubernetes.
- Incluye, según corresponda, recursos como `Deployment`, `Service`, `Ingress` o cualquier otro que aporte valor a la solución.

Se recomienda separar los manifiestos por carpetas o por componente, por ejemplo:

- `namespace/` para el namespace;
- `front/`, `back/`, `auth/` para los `Deployment` y `Service` de cada componente;
- `auth-db/` para la base de datos;
- `ingress/` para el acceso externo;
- `secret/` para configuración sensible;
- `kustomization.yaml` para agrupar todo.

El objetivo no es acumular muchos YAML, sino que estén ordenados y sea fácil entender qué despliega cada archivo.

### 4. Salud y operabilidad

- Configura probes de salud adecuadas para la aplicación:
  - `livenessProbe`
  - `readinessProbe`

### 5. Ejecución en Minikube

- Despliega la solución en un clúster local con Minikube.
- Verifica que la aplicación queda accesible y funcionando correctamente.

Como ayuda, puedes apoyarte en scripts que automaticen parte del trabajo. Por ejemplo, tiene sentido disponer de scripts para:

- construir imágenes;
- reconstruir imágenes con una versión concreta;
- aplicar manifiestos;
- reiniciar despliegues;
- limpiar Minikube o el despliegue.

Un ejemplo útil es un script del estilo `scripts/build-minikube-images.sh <version>`, que:

- construye las imágenes con una etiqueta concreta;
- usa el Docker daemon de Minikube;
- actualiza los `deployment.yaml` para que las imágenes apunten a esa misma versión.

Ese tipo de automatización aporta valor porque mejora la coherencia entre lo construido y lo desplegado.

### 6. Gestión GitOps con Argo CD

- Configura Argo CD para gestionar el despliegue desde el repositorio Git.
- Define el estado deseado de la aplicación en Git y sincronízalo con el clúster.

Se recomienda separar claramente en `argocd/`:

- la definición de la `Application`;
- la configuración del repositorio que Argo CD necesita para leer Git.

Por ejemplo:

- `argocd/application/upm.yaml`: define la `Application` y la ruta del repositorio que debe sincronizarse;
- `argocd/repo/repo-upm-secret-ssh.yaml`: registra el repositorio usando acceso SSH;
- `argocd/repo/repo-upm-secret-https.yaml`: alternativa con acceso HTTPS.

Si se usan secretos con credenciales, deben tratarse como material sensible y documentarse con placeholders o valores de ejemplo cuando sea necesario.

## Entregables

La entrega debe incluir, como mínimo:

- enlace al repositorio de GitHub;
- capturas o evidencias del funcionamiento en Minikube y Argo CD, o los hitos que se hayan conseguido. Capturas de pantalla en una carpeta docs/, por ejemplo;
- un `README` detallado que explique las decisiones técnicas tomadas durante el proyecto, incluyendo el razonamiento detrás de ellas y cualquier aspecto que aporte valor o contexto a la entrega.

## Contenido mínimo esperado en el README

Como referencia, debería hacer una descripción del proyecto y responder preguntas como:

- ¿Cómo está organizada la estructura de carpetas del repositorio y por qué?
- ¿Qué hace cada carpeta principal?
- ¿Qué recursos de Kubernetes se han definido y con qué propósito?
- ¿Cómo se construyen las imágenes y cómo se versionan?
- ¿Qué scripts de apoyo existen y para qué sirven?
- ¿Cómo está organizada la carpeta `argocd` y qué papel tiene cada YAML?
- ¿En qué orden se aplicarían los manifiestos de Argo CD si fuera necesario hacerlo manualmente?
- ¿Qué mejoras futuras serían razonables si el proyecto evolucionara?

El `README` debe ayudar a corregir y entender la entrega rápidamente. Si la solución no funciona al 100 %, la documentación debe dejar claro qué está hecho, qué falta y cómo está pensada la estructura.

## Resultado esperado

Al finalizar la práctica, debe existir una aplicación web funcional, desplegada en Minikube, gestionada de forma declarativa mediante manifiestos de Kubernetes y sincronizada desde Git mediante Argo CD.

En cualquier caso, el criterio principal será que la estructura de carpetas y archivos sea sólida, comprensible y coherente con la solución propuesta.
