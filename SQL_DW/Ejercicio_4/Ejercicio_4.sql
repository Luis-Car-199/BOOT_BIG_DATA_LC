--Ejercicio 4
--Traer de la tabla ivr_details calls_ivr_id (que es el mismo que en calls) y crear un nuevo campo vdn_aggregation con la siguiente logica:
--es una generalización del campo vdn_label. Si vdn_label empieza por ATC pondremos FRONT, si empieza por TECH pondremos TECH si es ABSORPTION
--dejaremos ABSORPTION y si no es ninguna de las anteriores pondremos RESTO.
-- por si acaso hay registros en mayusculas/minusculas paso la columna vdn_label a mayusculas y lo comparamos con las letras en mayuscula
select
  ivr_id as calls_ivr_id,
  case
    when upper(vdn_label) like 'ATC%' then 'FRONT'
    when upper(vdn_label) like 'TECH' then 'TECH'
    when upper(vdn_label) like 'ABSORTION' then 'ABSORTION'
    else 'RESTO'
    end as vdn_aggregation
from `keepcoding.calls`
;