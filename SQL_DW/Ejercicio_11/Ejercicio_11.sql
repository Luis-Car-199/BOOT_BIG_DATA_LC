--Ejercicio_11
-- Como en el ejercicio anterior queremos tener un registro por cada llamada y dos flags que indiquen si el calls_phone_number tiene una llamada las anteriores 24 horas o en las siguientes 24 horas. En caso afirmativo pondremos un 1 en estos flag, de lo contrario llevará un 0.

-- He comprobado que hay muchos de una llamada y por tanto habra muchos nulls. A estos nulls se les asigna un cero directamemte
with fecha_anterior_posterior as (
  select 
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
  case
    when timestamp_diff(end_date, fecha_anterior, hour) < 24 and fecha_anterior is not null then 1
    else 0
  end as repeated_phone_24H,
  case
    when timestamp_diff(start_date, fecha_posterior, hour) < 24 and fecha_anterior is not null then 1
    else 0
  end as cause_recall_phone_24,
from fecha_anterior_posterior
  
;
