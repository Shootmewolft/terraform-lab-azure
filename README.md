## Arquitectura en la Nube — Azure con Terraform

Proyecto de infraestructura como código (IaC) que implementa una arquitectura de red segmentada en Azure, replicando un entorno on-premise con subredes funcionales, bases de datos administradas y una aplicación web con conectividad privada.

---

### Tabla de contenidos

- [Estructura del proyecto](#estructura-del-proyecto)
- [Arquitectura general](#arquitectura-general)
- [Redes virtuales y subredes](#redes-virtuales-y-subredes)
- [VNet Peering](#vnet-peering)
- [Network Security Groups (NSGs)](#network-security-groups-nsgs)
- [Azure Bastion](#azure-bastion)
- [Máquina virtual de administración](#máquina-virtual-de-administración)
- [Base de datos — MySQL Flexible Server](#base-de-datos--mysql-flexible-server)
- [Web App — App Service](#web-app--app-service)
- [Aplicación PHP](#aplicación-php)
- [Despliegue](#despliegue)
- [Variables de configuración](#variables-de-configuración)

---

### Estructura del proyecto

```
terraform-lab-azure/
├── app/
│   └── index.php                  # Aplicación PHP que conecta a MySQL
├── environments/
│   └── dev/
│       ├── main.tf                # Orquestación de módulos
│       ├── outputs.tf             # Outputs del entorno
│       ├── provider.tf            # Proveedor Azure y versión de Terraform
│       ├── terraform.tfvars       # Valores de variables para dev
│       └── variables.tf           # Declaración de variables
└── modules/
    ├── bastion/                   # Azure Bastion Host
    ├── mysql/                     # MySQL Flexible Server + DNS privado
    ├── networking/                # VNets, subredes y peerings
    ├── nsg/                       # Network Security Groups y reglas
    ├── resource_group/            # Resource Group
    ├── vm/                        # VM Windows de administración
    └── webapp/                    # App Service + Web App PHP
```

Cada módulo contiene `main.tf`, `variables.tf` y `outputs.tf`.

---

### Arquitectura general

```
                         ┌─────────────────────────────────────────────┐
                         │            INTERNET                         │
                         └──────┬──────────────────────┬───────────────┘
                                │ HTTP/HTTPS (80,443)  │
                                ▼                      ▼
                  ┌─────────────────────────┐   ┌─────────────┐
                  │      VNet DMZ           │   │ Azure       │
                  │      10.1.0.0/16        │   │ Bastion     │
                  │                         │   └──────┬──────┘
                  │  ┌───────────────────┐  │          │
                  │  │ snet-dmz          │  │          │
                  │  │ 10.1.0.0/24       │  │          │
                  │  └───────────────────┘  │          │
                  │  ┌───────────────────┐  │          │
                  │  │ snet-webapp       │  │          │
                  │  │ 10.1.1.0/24       │  │          │
                  │  │ (App Service)     │  │          │
                  │  └────────┬──────────┘  │          │
                  └───────────┼─────────────┘          │
                     Peering  │  3306                   │
                  ┌───────────┼─────────────────────────┼──────────────┐
                  │           ▼                         ▼              │
                  │      VNet Producción — 10.0.0.0/16                 │
                  │                                                    │
                  │  ┌───────────────────┐  ┌───────────────────────┐  │
                  │  │ snet-prd          │  │ AzureBastionSubnet    │  │
                  │  │ 10.0.0.0/24       │  │ 10.0.2.0/26           │  │
                  │  └───────────────────┘  └───────────────────────┘  │
                  │  ┌───────────────────┐  ┌───────────────────────┐  │
                  │  │ snet-dev-qas      │  │ snet-lan              │  │
                  │  │ 10.0.1.0/24       │  │ 10.0.3.0/24           │  │
                  │  └───────────────────┘  │ (VM Admin Windows)    │  │
                  │  ┌───────────────────┐  └───────────────────────┘  │
                  │  │ snet-mysql        │                             │
                  │  │ 10.0.4.0/24       │                             │
                  │  │ (MySQL Flexible)  │                             │
                  │  └───────────────────┘                             │
                  └────────────────────────────────────┬───────────────┘
                                              Peering  │
                  ┌────────────────────────────────────┼───────────────┐
                  │      VNet CTG — 10.3.0.0/16        │               │
                  │  ┌───────────────────┐             │               │
                  │  │ snet-ctg          │  ◄──────────┘               │
                  │  │ 10.3.0.0/24       │                             │
                  │  └───────────────────┘                             │
                  └────────────────────────────────────────────────────┘
```

---

### Redes virtuales y subredes

Se crean **3 VNets** que representan las zonas de la topología on-premise:

| VNet | CIDR | Propósito |
|------|------|-----------|
| **Producción** | `10.0.0.0/16` | Contiene PRD, DEV-QAS, LAN, Bastion y MySQL |
| **CTG** | `10.3.0.0/16` | Zona de contingencia |
| **DMZ** | `10.1.0.0/16` | Zona desmilitarizada (Web App expuesta a Internet) |

**Subredes:**

| Subred | VNet | CIDR | Uso |
|--------|------|------|-----|
| `snet-prd` | Producción | `10.0.0.0/24` | Servidores SAP PRD, Active Directory |
| `snet-dev-qas` | Producción | `10.0.1.0/24` | Ambientes de desarrollo y QA |
| `AzureBastionSubnet` | Producción | `10.0.2.0/26` | Azure Bastion (nombre obligatorio de Azure) |
| `snet-lan` | Producción | `10.0.3.0/24` | Red interna — VM de administración |
| `snet-mysql` | Producción | `10.0.4.0/24` | MySQL Flexible Server (delegada) |
| `snet-ctg` | CTG | `10.3.0.0/24` | Contingencia |
| `snet-dmz` | DMZ | `10.1.0.0/24` | Zona pública DMZ |
| `snet-webapp` | DMZ | `10.1.1.0/24` | VNet Integration de App Service (delegada) |

La subred `snet-mysql` tiene delegación a `Microsoft.DBforMySQL/flexibleServers` y `snet-webapp` tiene delegación a `Microsoft.Web/serverFarms`.

---

### VNet Peering

Las 3 VNets están conectadas entre sí con peering bidireccional para permitir la comunicación controlada por NSGs:

```
Producción ◄────► CTG
Producción ◄────► DMZ
CTG        ◄────► DMZ
```

Todos los peerings habilitan `allow_virtual_network_access` y `allow_forwarded_traffic`.

---

### Network Security Groups (NSGs)

Se crea **un NSG por subred** (7 en total), cada uno con al menos 3 reglas personalizadas incluyendo reglas de denegación. Todas las reglas están definidas en el módulo `nsg/`.

#### NSG — Subred PRD (`nsg-prd`)

| Prioridad | Dirección | Acción | Origen | Puerto destino | Descripción |
|-----------|-----------|--------|--------|----------------|-------------|
| 100 | Inbound | Allow | LAN (10.0.3.0/24) | 3389 | RDP desde LAN |
| 110 | Inbound | Allow | LAN (10.0.3.0/24) | 22 | SSH desde LAN |
| 120 | Inbound | Allow | DEV-QAS (10.0.1.0/24) | 3200, 443 | SAP/HTTPS desde DEV-QAS |
| 130 | Inbound | Deny | CTG (10.3.0.0/24) | * | Bloquear CTG |
| 140 | Inbound | Deny | DMZ (10.1.0.0/24) | * | Bloquear DMZ |

#### NSG — Subred DEV-QAS (`nsg-dev-qas`)

| Prioridad | Dirección | Acción | Origen | Puerto destino | Descripción |
|-----------|-----------|--------|--------|----------------|-------------|
| 100 | Inbound | Allow | LAN (10.0.3.0/24) | 3389 | RDP desde LAN |
| 110 | Inbound | Allow | LAN (10.0.3.0/24) | 22 | SSH desde LAN |
| 120 | Inbound | Deny | DMZ (10.1.0.0/24) | * | Bloquear DMZ |
| 130 | Inbound | Deny | Internet | * | Bloquear Internet |

> El tráfico bidireccional DEV↔QAS es intra-subred (misma subnet), por lo que no atraviesa el NSG.

#### NSG — Subred CTG (`nsg-ctg`)

| Prioridad | Dirección | Acción | Origen/Destino | Puerto destino | Descripción |
|-----------|-----------|--------|----------------|----------------|-------------|
| 100 | Inbound | Allow | LAN (10.0.3.0/24) | 3389 | RDP desde LAN |
| 110 | Inbound | Allow | LAN (10.0.3.0/24) | 22 | SSH desde LAN |
| 100 | Outbound | Allow | * → PRD (10.0.0.0/24) | 53 | DNS hacia AD PRD |
| 110 | Outbound | Allow | * → PRD (10.0.0.0/24) | 389 | LDAP hacia AD PRD |
| 120 | Outbound | Deny | * → PRD (10.0.0.0/24) | * | Bloquear resto a PRD |
| 130 | Outbound | Deny | * → DMZ (10.1.0.0/24) | * | Bloquear DMZ |

#### NSG — Subred DMZ (`nsg-dmz`)

| Prioridad | Dirección | Acción | Origen/Destino | Puerto destino | Descripción |
|-----------|-----------|--------|----------------|----------------|-------------|
| 100 | Inbound | Allow | Internet | 80 | HTTP público |
| 110 | Inbound | Allow | Internet | 443 | HTTPS público |
| 120 | Inbound | Allow | PRD (10.0.0.0/24) | 22, 445 | SSH/SMB interno desde PRD |
| 130 | Outbound | Deny | * → PRD (10.0.0.0/24) | * | Bloquear salida a PRD |
| 140 | Outbound | Deny | * → CTG (10.3.0.0/24) | * | Bloquear salida a CTG |

#### NSG — Subred LAN (`nsg-lan`)

| Prioridad | Dirección | Acción | Destino | Puerto destino | Descripción |
|-----------|-----------|--------|---------|----------------|-------------|
| 100 | Outbound | Allow | PRD (10.0.0.0/24) | 389 | LDAP a AD |
| 110 | Outbound | Allow | PRD (10.0.0.0/24) | 88 | Kerberos a AD |
| 120 | Outbound | Allow | PRD (10.0.0.0/24) | 445 | SMB a AD |
| 130 | Outbound | Allow | PRD (10.0.0.0/24) | 53 | DNS a AD |
| 140 | Outbound | Allow | PRD (10.0.0.0/24) | 3200, 443 | SAP |
| 150 | Outbound | Allow | MySQL (10.0.4.0/24) | 3306 | Base de datos |
| 160 | Outbound | Allow | DMZ (10.1.0.0/24) | 80, 443 | HTTP/HTTPS a DMZ |
| 170 | Outbound | Deny | DMZ (10.1.0.0/24) | * | Bloquear resto a DMZ |

#### NSG — Subred MySQL (`nsg-mysql`)

| Prioridad | Dirección | Acción | Origen | Puerto destino | Descripción |
|-----------|-----------|--------|--------|----------------|-------------|
| 100 | Inbound | Allow | PRD (10.0.0.0/24) | 3306 | MySQL desde PRD |
| 110 | Inbound | Allow | LAN (10.0.3.0/24) | 3306 | MySQL desde LAN |
| 115 | Inbound | Allow | WebApp (10.1.1.0/24) | 3306 | MySQL desde Web App |
| 120 | Inbound | Deny | CTG (10.3.0.0/24) | * | Bloquear CTG |
| 130 | Inbound | Deny | DMZ (10.1.0.0/24) | * | Bloquear DMZ |

#### NSG — Subred WebApp (`nsg-webapp`)

| Prioridad | Dirección | Acción | Destino | Puerto destino | Descripción |
|-----------|-----------|--------|---------|----------------|-------------|
| 100 | Outbound | Allow | MySQL (10.0.4.0/24) | 3306 | Conexión a BD |
| 110 | Outbound | Deny | CTG (10.3.0.0/24) | * | Bloquear CTG |
| 120 | Outbound | Deny | LAN (10.0.3.0/24) | * | Bloquear LAN |

---

### Azure Bastion

Proporciona acceso RDP/SSH seguro a las VMs **sin necesidad de IP pública ni VPN**.

- **SKU:** Basic
- **Subred:** `AzureBastionSubnet` (10.0.2.0/26) dentro de VNet Producción
- **IP pública:** Static, SKU Standard (requerido por Bastion)

Desde Azure Bastion en la VNet Producción, se puede acceder a la VM de administración en la subred LAN y, mediante peering, a VMs en las demás VNets.

---

### Máquina virtual de administración

VM Windows desplegada en la subred LAN para administración remota vía Bastion.

| Propiedad | Valor |
|-----------|-------|
| **SO** | Windows Server 2022 Datacenter Azure Edition |
| **Tamaño** | Standard_D2s_v3 |
| **Subred** | snet-lan (10.0.3.0/24) |
| **IP** | Privada (dinámica, sin IP pública) |
| **Disco OS** | Standard_LRS |

Se accede únicamente a través de Azure Bastion (no tiene IP pública).

---

### Base de datos — MySQL Flexible Server

Servidor MySQL administrado desplegado con acceso exclusivamente privado.

| Propiedad | Valor |
|-----------|-------|
| **SKU** | B_Standard_B1ms (Burstable, 1 vCore, 2 GB RAM) |
| **Versión** | 8.0.21 |
| **Almacenamiento** | 20 GB |
| **Subred delegada** | snet-mysql (10.0.4.0/24) |
| **Acceso público** | Deshabilitado (solo red privada) |
| **Backup** | 7 días de retención |

**DNS privado:** Se crea una Private DNS Zone (`<server-name>.private.mysql.database.azure.com`) con links a VNet Producción y VNet DMZ, permitiendo la resolución de nombres desde ambas redes.

**Parámetros configurados:**

| Parámetro | Valor |
|-----------|-------|
| `time_zone` | -05:00 (Colombia) |
| `max_connections` | 100 |
| `wait_timeout` | 300 segundos |

**Acceso controlado por NSG:** Solo se permite tráfico al puerto 3306 desde las subredes PRD, LAN y WebApp. CTG y DMZ están bloqueadas explícitamente.

---

### Web App — App Service

Aplicación web PHP desplegada en Azure App Service con integración de red virtual.

| Propiedad | Valor |
|-----------|-------|
| **OS** | Linux |
| **SKU** | B1 (Basic) |
| **Stack** | PHP 8.2 |
| **VNet Integration** | snet-webapp (10.1.1.0/24) en VNet DMZ |
| **Acceso público** | Sí (HTTP/HTTPS desde Internet) |

**Conexión a MySQL:** Configurada mediante App Settings y Connection Strings de Azure:

- `MYSQL_HOST` → FQDN del MySQL Flexible Server
- `MYSQL_DATABASE` → Nombre de la base de datos
- `MYSQL_USER` → Usuario administrador
- `MYSQLCONNSTR_MySQLConnection` → Connection string completo con password

La Web App sale a la red a través de la subred `snet-webapp` (VNet Integration), lo que le permite alcanzar el MySQL Flexible Server en la subred `snet-mysql` vía VNet Peering (DMZ → Producción).

---

### Aplicación PHP

El archivo `app/index.php` es una aplicación de prueba que:

1. Lee las variables de entorno configuradas en App Service
2. Extrae el password desde el connection string `MYSQLCONNSTR_MySQLConnection`
3. Conecta a MySQL Flexible Server vía PDO con SSL
4. Muestra la versión de MySQL y lista las bases de datos disponibles
5. Maneja errores de conexión con mensajes descriptivos

---

### Despliegue

**Requisitos previos:**
- Terraform >= 1.5.0
- Provider `azurerm` ~> 3.117
- Suscripción de Azure con permisos suficientes

**Comandos:**

```bash
cd environments/dev

# Inicializar Terraform y descargar providers
terraform init

# Revisar los cambios planificados
terraform plan

# Aplicar la infraestructura
terraform apply
```

**Despliegue de la aplicación PHP:**

Después de aplicar la infraestructura, subir el contenido de `app/` a la Web App mediante Azure CLI, zip deploy, o desde el portal de Azure.

```bash
cd ../../app
zip -r app.zip .
az webapp deploy --resource-group rg-arq-nube-dev --name app-arqnube-dev --src-path app.zip --type zip
```

---

### Variables de configuración

Todas las variables se definen en `environments/dev/variables.tf` y sus valores en `terraform.tfvars`.

| Variable | Descripción | Valor en dev |
|----------|-------------|--------------|
| `location` | Región Azure | eastus |
| `resource_group_name` | Nombre del Resource Group | rg-arq-nube-dev |
| `vnet_prod_cidr` | CIDR VNet Producción | 10.0.0.0/16 |
| `vnet_ctg_cidr` | CIDR VNet CTG | 10.3.0.0/16 |
| `vnet_dmz_cidr` | CIDR VNet DMZ | 10.1.0.0/16 |
| `subnet_prd_cidr` | Subred PRD | 10.0.0.0/24 |
| `subnet_dev_qas_cidr` | Subred DEV-QAS | 10.0.1.0/24 |
| `subnet_bastion_cidr` | Subred Bastion | 10.0.2.0/26 |
| `subnet_lan_cidr` | Subred LAN | 10.0.3.0/24 |
| `subnet_mysql_cidr` | Subred MySQL | 10.0.4.0/24 |
| `subnet_ctg_cidr` | Subred CTG | 10.3.0.0/24 |
| `subnet_dmz_cidr` | Subred DMZ | 10.1.0.0/24 |
| `subnet_webapp_cidr` | Subred WebApp | 10.1.1.0/24 |
| `admin_vm_size` | Tamaño VM admin | Standard_D2s_v3 |
| `mysql_sku_name` | SKU MySQL | B_Standard_B1ms |
| `mysql_storage_gb` | Almacenamiento MySQL | 20 GB |
| `mysql_version` | Versión MySQL | 8.0.21 |
| `app_service_sku` | SKU App Service | B1 |
