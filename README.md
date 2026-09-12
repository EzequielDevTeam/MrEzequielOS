<!--
SPDX-FileCopyrightText: EzequielDevTeam (MrEzequielOS)
SPDX-License-Identifier: Apache-2.0
-->
# MrEzequielOS

> ROM custom feita no Brasil por **Ezequiel (EzequielDevTeam)**, baseada no
> LineageOS 23.2 (Android 16) em formato **GSI Treble**. Modifique do seu jeito.

Site: https://ezequieldevteam.github.io · Discord: https://discord.gg/tPKhmnRnCH

## O que é

Uma imagem GSI única que roda em qualquer aparelho Project Treble, com seção
própria dentro do Configurações (**MrEzequielOS**): Temas, Motor Monet, Barra de
status, Quick Settings, Notificações, Diversos, Tela de bloqueio, Cuidado do
dispositivo e Dynamic Bar. Sem Google por padrão, com **MicroG** opcional e apps
abertos de fábrica (F-Droid, Aurora Store, BCR, Tweaker).

## Baixar (GSI)

As builds saem na aba **[Releases](../../releases)** deste repositório:
`system.img` + instruções de flash via fastboot.

## Compilar

```bash
repo init -u https://github.com/EzequielDevTeam/MrEzequielOS.git -b lineage-23.2 --git-lfs
repo sync
bash vendor/extra/apps/fetch-apks.sh
source build/envsetup.sh
lunch mrezequiel_gsi-bp4a-userdebug
m systemimage -j$(nproc)
```

O manifest usa a estratégia `snippets/`: `default.xml` (base LineageOS) +
`snippets/mrezequiel.xml` (forks EzequielDevTeam + projetos próprios + treble
Doze-off). APKs e fontes binárias **não** vão ao git — o `fetch-apks.sh`
baixa os oficiais (ver `ATTRIBUTION`).

## Créditos

Base: **LineageOS** + AOSP. Inspiração e código: **Evolution X**, **crDroid**,
**AxionOS**, **microG**, **phh treble / Doze-off**, **F-Droid**, **Aurora**,
**BCR**, **Tweaker**, **Twemoji/Mozilla**. Licenças abertas respeitadas
(Apache/MIT/CC-BY/GPL), autores preservados no git e em `CREDITS.md` na ROM.
Detalhe completo na tela **Sobre** do aparelho.
