-- Ejercicio_10
-- Este ejercicio le entiendo igual que el anterior solo que cambiando la condicion del step_name

with flag as (
  select
    ivr_id,
    step_name,
    step_result,
    case
      when step_name = 'CUSTOMERINFOBYDNI.TX' and step_result = 'OK' then 1
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
