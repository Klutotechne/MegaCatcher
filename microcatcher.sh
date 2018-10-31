#!/bin/bash
#---------------------------------------------------------------------------------------------------
#
# Script para coleta de dados de Comtech EF Data Modem
# Autores: Derik Adan
#          Rafael Augusto
# Data: 31 de outubro de 2018
# QUARTO CENTRO INTEGRADO DE DEFESA AÉREA E CONTROLE DE TRÁFEGO AÉREO
# Subseção de Tecnologia da informação
# Informática operacional
#
#---------------------------------------------------------------------------------------------------
#------------------------------[ CONSTANTES ]------------------------------
# Localização do arquivo de base de dados
CONFIG="megacatcher.conf"
SEP=:
# TEMP=temp.$$
# MASCARA=
#---------------------------------------------------------------------------------------------------

#------------------------------[ FUNÇÕES ]------------------------------
# # O arquivo texto com a base de dados já deve estar definido
# [ "$BASE_DE_DADOS" ] || {
#         echo "Base de dados não informada. Use a variável BASE_DE_DADOS."
#         return 1
# }
#
# # O arquivo deve poder ser lido e gravado
# [ -r "$BASE_DE_DADOS" -a -w "$BASE_DE_DADOS" ] || {
#         echo "Base travada , confira as permissões de leitura e escrita."
#         return 1
# }
#
# # Verifica se a chave $1 está no banco
# tem_registro(){
#         grep -i -q "^$1$SEP" "$BASE_DE_DADOS"
# }
#
# apaga_registro(){
#         tem_registro "$1" || return                             # não tente se não houver
#         grep -i -v "^$1$SEP" "$BASE_DE_DADOS" > "$TEMP"         # apaga a chave
#         mv "$TEMP" "$BASE_DE_DADOS"                             # regrava a base
#         echo "O registro '$1' foi apagado."
# }
#
# # Insere o registro $* na base
# insere_registro(){
#         local registro=$(echo "$1" | cut -d $SEP -f1)           # pega primeiro campo
#         if tem_registro "$registro"; then
#                 echo "A ODU '$registro' já está cadastrada na base de dados."
#                 return 1
#         else
#                 echo "$*" >> "$BASE_DE_DADOS"                   # grava o registro
#                 echo "Registro de '$registro' cadastrado com sucesso."
#         fi
#         return 0
# }

#---------------------------------------------------------------------------------------------------

#------------------------------[ FUNÇÕES ]------------------------------

while IFS='' read -read line || [[ -n "$line" ]]; do

DESTACAMENTO=``
IP_CDM=``
`curl 'http://'$IP_CDM'/Forms/csat_status_1' -H 'Host: '$IP_CDM'' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-GB,en;q=0.5' --compressed -H 'Referer: http://'$IP_CDM'/odu/csat_status.htm' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Authorization: Basic Y29tdGVjaDpjb210ZWNo' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data 'oduselect=1&Submit=Select+ODU'`

`curl 'http://'$IP_CDM'/odu/csat_status.htm' -H 'Host: '$IP_CDM'' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-GB,en;q=0.5' --compressed -H 'Referer: http://'$IP_CDM'/odu/csat_status.htm' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1'`
done < $BASE_CADASTRO


#--------------[ SELEÇÃO DE ODUs ]---------------
Menu_Principal=$(dialog --stdout \
        --menu "Mega Catcher" \
        0 0 0 \
        Selecionar "Selecionar ODUs a monitorar" \
        Adicionar "Adicionar novas ODUs" \
        Remover "Remover ODUs do sistema")

case "$Menu_Principal" in
        Selecionar)
                # Abre novo menu de seleção das ODUs a monitorar
                monitorar=$(dialog --stdout --radiolist "" 0 0 0 )

        ;;
        Adicionar)
                IP_ODU=$(dialog --stdout --imputbox "Digite o IP da ODU:" 0 0)
                [ "$IP_ODU" ] || exit 1

                # Confere se já existe o cadastro da ODU
                tem_chave "$IP_ODU" && {
                        msg="Já existe um cadastro de ODU com IP: '$IP_ODU'"
                        dialog --msgbox "$msg" 6 40
                        exit 1
                }

                # Novo cadastro
                Nome_ODU=$(dialog --stdout --inputbox "DTCEA-XX:" 0 0)
        ;;
esac
