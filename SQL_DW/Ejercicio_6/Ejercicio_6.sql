--Ejercicio 6
-- queremos un registro para cada llamada y un solo cliente identificado en la misma
-- hay que identificarlo a traves del numero de tlf que esta en calls. Con una primera prueba del rownumber estoy viendo que hay varios telefonos por registro, lo suyo seria separar en dos registros los id que tengan asignados numeros de telefono distintos para asi no perderlos y poder cruzarlos aposteriori

-- compruebo los registros que hay y los numeros de telefono
select 
  count(*) as total_records,
  count(distinct ivr_id) as unique_records,
  count(distinct phone_number) as unique_records2
from `keepcoding.calls`
;
 -- comprueba que numeros de telefono han llamado más de una vez
select 
  phone_number
from `keepcoding.calls`
group by all
having count (*) > 1
;

-- compruebo que hay varios ivr_id que estan repetidos y tienen distinto numero de tlf.
with calls_2 as (
select
  cast(ivr_id as INT64) as ivr_id,
  phone_number as customer_phone,
  end_date,
  row_number() over(partition by cast(ivr_id as INT64) order by end_date desc) as rn
from `keepcoding.calls` 
)

--select * 
--from calls_2
--where rn >4

-- en el rownumber vemos que no hay mas de 4, lo suyo seria hacer un flag para cada caso y asi mantener los numeros dierentes en los id y hacer un distinc por numero de telefono por si hubiera alguno duplicado. De esta manera aseguramos que que hay un unico registro y un unico numero identificador.

select
  ivr_id,
  customer_phone,
  case
    when rn = 2 then concat(ivr_id, '-2' )
    when rn = 3 then concat(ivr_id, '-3' )
    when rn = 4 then concat(ivr_id, '-4' )
    else cast(ivr_id as string)
  end as new_ivr_id
from calls_2 
order by calls_2.ivr_id;

--NO SE SI ME HE LIADO CON EL EJERCICIO O LO HE ENTENDIDO MAL   :s




