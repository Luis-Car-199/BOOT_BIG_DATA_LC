--Ejercicio_12
-- juntar todo el trabajo 
with vdn_agregation as (

  select
  ivr_id,
  case
    when upper(vdn_label) like 'ATC%' then 'FRONT'
    when upper(vdn_label) like 'TECH' then 'TECH'
    when upper(vdn_label) like 'ABSORTION' then 'ABSORTION'
    else 'RESTO'
    end as vdn_aggregation
from `keepcoding.calls`
),

document_type_identification as (
  select
  cast(call.ivr_id as INT64) as ivr_id,
  step.document_identification,
  step.document_type,  
from `keepcoding.calls` call
left join `keepcoding.steps`  step 
on call.ivr_id = step.ivr_id
where document_type != 'UNKNOWN' 
qualify row_number() over(partition by cast(call.ivr_id as INT64) order by document_identification) = 1


),

customer_phone as (
  with calls_2 as (
  select
  cast(ivr_id as INT64) as ivr_id,
  phone_number as customer_phone,
  end_date,
  row_number() over(partition by cast(ivr_id as INT64) order by end_date desc) as rn
from `keepcoding.calls` 


)


select distinct
  ivr_id,
  customer_phone,
  case
    when rn = 2 then concat(ivr_id, '-2' )
    when rn = 3 then concat(ivr_id, '-3' )
    when rn = 4 then concat(ivr_id, '-4' )
    else cast(ivr_id as string)
  end as new_ivr_id
from calls_2 
order by calls_2.ivr_id

),

billing_account as (
  with all_calls as (
select
  cal.ivr_id,
  ste.billing_account_id,
  cal.end_date,
from `keepcoding.calls` cal
left join `keepcoding.steps` ste 
on cal.ivr_id = ste.ivr_id
where ste.billing_account_id != 'UNKNOWN'
group by cal.ivr_id,ste.billing_account_id,cal.end_date
),

rown as ( 
  select distinct
    cast(ivr_id as int64) as ivr_id,
    billing_account_id,
    end_date,
    row_number() over(partition by cast(ivr_id as INT64) order by end_date desc ) as rn
  from all_calls
)
select 
  ivr_id,
  billing_account_id,
  case
    when rn > 1 then concat(cast(ivr_id as string), '-' , cast(rn as string))
    else cast(ivr_id as string)
    end as new_ivr_id
  from rown
  where billing_account_id != 'UNKNOWN'


),

masiva_lg as (
  with flag as(
  select
    ivr_id,
    upper(module_name) as module_name,
  case 
    when module_name in ('AVERIA_MASIVA') then 1
    else 0
  end as masiva_lg
  from `keepcoding.modules` 
  order by ivr_id
)

select
  cal.ivr_id,
  max(fla.masiva_lg) as masiva_lg
from `keepcoding.calls` cal 
join flag fla
on cal.ivr_id = fla.ivr_id
group by cal.ivr_id
order by cal.ivr_id desc

),

info_by_phone as (
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
  
)

select 
  cal.ivr_id,
  max(fla.info_by_phone_lg) as info_by_phone_lg
from `keepcoding.calls` cal 
left join flag fla
on cal.ivr_id = fla.ivr_id
group by cal.ivr_id

),

info_by_dni as (
  with flag as (
    select
      ivr_id,
      step_name,
      step_result,
      case
        when step_name = 'CUSTOMERINFOBYDNI.TX' and step_result = 'OK' then 1
        else 0
      end as info_by_dni_lg

    from `keepcoding.steps` 
 
)

select 
  cal.ivr_id,
  max(fla.info_by_dni_lg) as info_by_dni_lg
from `keepcoding.calls` cal 
left join flag fla
on cal.ivr_id = fla.ivr_id
group by cal.ivr_id

),

phone_24 as (
  with fecha_anterior_posterior as (
    select
    ivr_id,
    phone_number,
    start_date,
    end_date,
    lag(end_date) over(partition by phone_number order by end_date desc) as fecha_anterior,
    lead(start_date)  over (partition by phone_number order by start_date asc) as fecha_posterior

  from `keepcoding.calls`
  where phone_number != 'UNKNOWN'
)

select 
  phone_number,
  ivr_id,
  case
    when timestamp_diff(end_date, fecha_anterior, hour) < 24 and fecha_anterior is not null then 1
    else 0
  end as repeated_phone_24H,
  case
    when timestamp_diff(start_date, fecha_posterior, hour) < 24 and fecha_anterior is not null then 1
    else 0
  end as cause_recall_phone_24,
from fecha_anterior_posterior

)

select
  det.calls_ivr_id,
  det.calls_phone_number,
  det.calls_ivr_result,
  vdn.vdn_aggregation, 
  det.calls_start_date,
  det.calls_end_date,
  det.calls_total_duration,
  det.calls_customer_segment,
  det.calls_ivr_language,
  det.calls_steps_module, 
  det.calls_module_aggregation, 
  doc.document_type,
  doc.document_identification,
  cus.customer_phone,
  bil.billing_account_id,
  mas.masiva_lg,
  inf.info_by_phone_lg,
  info.info_by_dni_lg,
  phone.cause_recall_phone_24,
  phone.repeated_phone_24H
  
from `keepcoding.ivr_details` det
left join vdn_agregation vdn
on det.calls_ivr_id = vdn.ivr_id
left join document_type_identification doc
on doc.ivr_id = cast(det.calls_ivr_id as int64)
left join customer_phone cus 
on cus.ivr_id = cast(det.calls_ivr_id as int64)
left join billing_account bil 
on bil.ivr_id = cast(det.calls_ivr_id as int64)
left join masiva_lg mas
on mas.ivr_id = det.calls_ivr_id
left join info_by_phone inf
on inf.ivr_id = det.calls_ivr_id
left join info_by_dni info
on info.ivr_id = det.calls_ivr_id
left join phone_24 phone
on phone.ivr_id = det.calls_ivr_id
group by det.calls_ivr_id,
  det.calls_phone_number,
  det.calls_ivr_result,
  vdn.vdn_aggregation,
  det.calls_start_date,
  det.calls_end_date,
  det.calls_total_duration,
  det.calls_customer_segment,
  det.calls_ivr_language,
  det.calls_steps_module,
  det.calls_module_aggregation,
  doc.document_type,
  doc.document_identification,
  cus.customer_phone,
  bil.billing_account_id,
  mas.masiva_lg,
  inf.info_by_phone_lg,
  info.info_by_dni_lg,
  phone.cause_recall_phone_24,
  phone.repeated_phone_24H

;

 
--NO ENTIENDO PORQUE AL CASTEAR EL CALLS_IVR_ID COMO INT SI QUE LOS JUNTA (NO ME DA TODO NULOS) Y AL CATEAR COMO FLOAT (QUE ERA LO QUE LLEVABA INTENTANTO HACER UN BUEN RATO) NO. COMO PARA USAR EL ROW NUMBER TUVE QUE CASTEAR EL FLOAT A INT, QUERIA HACERLO DE INT A FLOAT PARA QUE TODO ESTUVIERA IGUAL Y PORQUE COMO ES EL QUE HABIA CAMBIADO, ME ENCABEZONE CON ELLO. ¿ESPORQUE ES UN FLOAT GENERICO? INTENTE HACERLO CON FLOAT64 Y CREO QUE NO ES ESE EL TIPO AUNQUE EN EL ESQUEMA DE LA TABLA PONGA FLOAT.
