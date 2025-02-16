--Ejercicio_8
--Como en el ejercicio anterior queremos tener un registro por cada llamada y un flag que indique si la llamada ha pasado por el módulo AVERIA_MASIVA. Si es así indicarlo con un 1 de lo contrario con un 0.

-- Primero vamos a selecionar de la tabla modules, las llamdas con su vri_id que han pasado por averia masiva. Cambiamos la coluna module_name a mayusculas por si se ha colado algun dato en minisculas y mayusculas asi nos aseguramos de coger todos.



with flag as(
select
  ivr_id,
  upper(module_name) as module_name,
  case 
  when module_name in ('AVERIA_MASIVA') then 1
  else 0
  end as flag
from `keepcoding.modules` 
order by ivr_id
)
-- al asignar el flag solo nos queda agrupar por el max del flag, si ha pasado por averia masiva y tiene un 1 cogera ese si tiene todo ceros cogera uno con un cero
select
  cal.ivr_id,
  max(fla.flag) as flag
from `keepcoding.calls` cal 
left join flag fla
on cal.ivr_id = fla.ivr_id
--where fla.flag = 1
group by cal.ivr_id
order by cal.ivr_id desc
;
