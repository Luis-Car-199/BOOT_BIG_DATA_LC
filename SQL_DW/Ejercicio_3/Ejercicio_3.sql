--Ejercicio 3
-- Creacion de una tabla auxiliar con todos los detalles con nombre ivr_detail. 
-- Crear dos columnas mas con la fecha formatendola a yyyymmdd como un id
--Generamos tabla con todas la informacion solicitada
CREATE TABLE keepcoding.ivr_details as
select
-- primero de la tabla calls
cal.ivr_id as calls_ivr_id,
cal.phone_number as calls_phone_number,
cal.ivr_result as calls_ivr_result,
cal.vdn_label as calls_vdn_label ,
cal.start_date as calls_start_date,
-- como el formato de las otras tablas es timestamp hay que formatearlo asi, con time no me deja
format_timestamp('%Y%m%d', cal.start_date) as calls_start_date_id,
cal.end_date as calls_end_date,
format_timestamp('%Y%m%d', cal.end_date) as calls_end_date_id,
cal.total_duration as calls_total_duration,
cal.customer_segment as calls_customer_segment ,
cal.ivr_language as calls_ivr_language,
cal.steps_module as calls_steps_module,
cal.module_aggregation as calls_module_aggregation,
-- tabla modulos
mod.module_sequece,
mod.module_name,
mod.module_duration,
mod.module_result,
-- tabla steps
ste.step_description_error,
ste.step_sequence,
ste.step_name,
ste.step_result,
ste.document_type,
ste.document_identification,
ste.customer_phone,
ste.billing_account_id
-- Hacemos los dos join para traer todos los datos
from `keepcoding.calls` cal
inner join `keepcoding.modules` mod
on cal.ivr_id = mod.ivr_id
inner join `keepcoding.steps` ste 
on ste.ivr_id = mod.ivr_id and ste.module_sequece = mod.module_sequece
;