######Crear en el host con el usuario root un alias para la interfaz loopback
>ifconfig lo:0 172.20.0.1

######Inicio imagen netbsd
>./xgxemul -e 3max -d netbsd-pmax.img -x

######Abrir el tunel a unix desde netbsd
>ssh -R 2222:127.0.0.1:22 $host_name@172.20.0.1

######Abrir shells remotos desde host contra guest
>ssh -p 2222 root@127.0.0.1

######Pasar el arch desde host al guest
>scp -P2222 -r ./tp1.s root@127.0.0.1:/root

######Pasar el arch desde guest al host
scp -P2222 root@127.0.0.1:/root/$tp_1 /home/$host_name

