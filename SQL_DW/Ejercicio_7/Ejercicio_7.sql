-- Ejercicio 7

-- En ocasiones es posible identificar al cliente en alguno de los pasos de detail obteniendo su número de cliente.
-- Queremos tener un registro por cada llamada y un sólo cliente identificado para la misma.


-- compruebo los registros que hay y los numeros de telefono
select 
  count(*) as total_records,
  count(distinct ivr_id) as unique_records,
  count(distinct billing_account_id) as unique_records2
from `keepcoding.steps`
;

-- Traigo los datos de todas las llamadas y los junto con el billing_count_id a traves de ivr_id. Al ordenarlos vemos que hay algunos ivr_id duplicados pero con distinto numero de telefono. Para no perder los numeros al quedarnos solo con 1 de los registros, voy a hacer como en el ejercicio anterior. Usare un distinct para eliminar los que sean exactamente iguales y asi no generar filas de mas y con un row_number vamos a asignar a los que tienen mismo id pero diferente billing un nuebo id 





--with all_calls as (
select --distinct
  cal.ivr_id,
  ste.billing_account_id,
  --count(distinct billing_account_id) as number_for_records, --> 18178
  --count (distinct cal.ivr_id) as calls_records
from `keepcoding.calls` cal
left join `keepcoding.steps` ste 
on cal.ivr_id = ste.ivr_id
where ste.billing_account_id != 'UNKNOWN'
group by ste.billing_account_id, cal.ivr_id
--having count(*) > 1 -- para ver si aparecen mas de una vez
order by ste.billing_account_id desc








--),

--rown as (
--  select 
--    cast(ivr_id as int64) as ivr_id,
--    billing_account_id,
--    row_number() over(partition by cast(ivr_id as INT64) order by ivr_id ) as rn
--  from all_calls
--)

--select 
--  ivr_id,
--  billing_account_id,
--  case
--    when rn > 1 then concat(cast(ivr_id as string), '-' , cast(rn as string))
--    else cast(ivr_id as string)
--    end as new_ivr_id
--  from rown
--  order by ivr_id , rn
; 


  
