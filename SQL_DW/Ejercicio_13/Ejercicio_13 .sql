--Ejercicio_13
-- Crear una funcion con reemplaze los null por -999999

create or replace function `keepcoding.clean_integer` (value int64)
returns int64 as (
  coalesce(value, -999999)
);

