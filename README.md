# Control Cobranza 3.0

Aplicación web Node.js + Express + PostgreSQL, pensada para abrirse desde Chrome en celular.

## Incluye
- Administrador, supervisor y cobrador.
- Clientes con teléfono, dirección y coordenadas.
- Préstamos diarios, semanales y mensuales.
- Generación automática de cuotas.
- Pagos parciales con bloqueo para no superar el saldo.
- Cobranza asignada por cobrador.
- Caja individual por cobrador.
- Solo administrador puede inyectar o retirar dinero de las cajas.
- Cada cobro entra automáticamente a la caja del cobrador.
- Gastos descontados de la caja correspondiente.
- Historial de movimientos y auditoría.
- Reporte de cobranza de 30 días.
- Diseño responsive para celular.

## Publicación
El repositorio incluye `render.yaml` para Render y `Dockerfile` como alternativa. Para pruebas `DEMO_OPEN=true` permite entrar sin login; para producción se recomienda ponerlo en `false` y usar las cuentas reales.

Cuenta inicial cuando el servidor crea una base vacía: `admin` / `1234`. Cámbiala antes de uso real.
