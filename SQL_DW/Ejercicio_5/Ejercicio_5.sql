--Ejercicio 5
--QUEREMOS TENER UN REGISTRO PARA CADA LLAMADA Y UNA IDENTIFICACION PARA LA MISMA
--con count del ivr_id he identificado que hay varios que estan duplicados
-- despues con rownumber sacamos un listado de los ivr_id que esten repetidos y igualandolo a 1 sacamos un unico registro (no hace falta ordenarlos puesto que sse pide una identificacio por cada llamada)

-- compruebo si hay duplicados en calls
select 
  count(*) as total_records,
  count(distinct ivr_id) as unique_records
from `keepcoding.calls`
;
-- compruebo si hay duplicados en steps(que si deberia ya que un cliente en una llamada puede pasar por varios modulos y hacer diferentes pasos)
select 
  count(*) as total_records,
  count(distinct ivr_id) as unique_records
from `keepcoding.steps`
;


-- Hago la seleccion con un left join desde calls y nos quedamos con una de las identificaciones por registro
select
  cast(call.ivr_id as INT64) as ivr_id,
  step.document_identification,
  step.document_type,
  --row_number() over(partition by cast(call.ivr_id as INT64) order by document_identification) as rn
  
from `keepcoding.calls` call
left join `keepcoding.steps`  step 
on call.ivr_id = step.ivr_id
where step.document_identification != 'UNKNOWN' and step.document_type != 'UNKNOWN' and step.document_identification is not null and step.document_type is not null
qualify row_number() over(partition by cast(call.ivr_id as INT64) order by document_identification) = 1

;

