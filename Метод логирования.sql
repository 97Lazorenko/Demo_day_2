
create or replace procedure lazorenko_al.add_error_log(
    p_object_name varchar2,
    p_params varchar2,
    p_log_type varchar2 default 'common'
)
as
pragma autonomous_transaction;
begin

    insert into lazorenko_al.error_log(object_name, log_type, params)
    values (p_object_name, p_log_type, p_params);

    commit;
end;
