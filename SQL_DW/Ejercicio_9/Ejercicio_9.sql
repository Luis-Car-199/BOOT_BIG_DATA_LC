-- Ejercicio 9
-- Como en el ejercicio anterior queremos tener un registro por cada llamada y un flag que indique sila llamada pasa por el step de nombre CUSTOMERINFOBYPHONE.TX y su step_result es OK, quiere decir que hemos podido identificar al cliente a través de su número de teléfono. En ese caso pondremos un 1 en este flag, de lo contrario llevará un 0.
-- Primero hacemos el flag asignando 1 a los que sean 'CUSTOMERINFOBYPHONE.TX' y OK a la vez
-- lo que queremos es un uno o un cero para identificar por cada llamada i sha pasado o no
with flag as (
  select
    ivr_id,
    step_name,
    step_result,
    case
      when step_name = 'CUSTOMERINFOBYPHONE.TX' and step_result = 'OK' then 1
      else 0
    end as info_by_phone_lg

  from `keepcoding.steps` 
  --where step_name = 'CUSTOMERINFOBYPHONE.TX' --and step_result = 'OK'
  --order by ivr_id desc
)
-- hay que agrupar por el max flag para quedarnos con un unico registro, si es 1 lo asignara y sino asignara un cero
select 
  cal.ivr_id,
  max(fla.info_by_phone_lg) as info_by_phone_lg
from `keepcoding.calls` cal 
left join flag fla
on cal.ivr_id = fla.ivr_id
group by cal.ivr_id
;
