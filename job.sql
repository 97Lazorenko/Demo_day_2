

--процедура для merge

create or replace procedure lazorenko_al.merge_and_insert_doctors(
v_out_result out number
)
as
    v_arr_doctor lazorenko_al.t_arr_doctor := lazorenko_al.t_arr_doctor();
begin
    v_arr_doctor := lazorenko_al.service_for_doctors(v_out_result);

  merge into lazorenko_al.doctor origin
    using (
        select doctor_id, hospital_id, name, fname, petronymic from table(v_arr_doctor)
    ) new
    on (
        origin.external_id = new.doctor_id
    )
    when matched then
        update set
           origin.name = new.name,
           origin.fname = new.fname,
           origin.petronymic = new.petronymic,
           origin.hospital_id = new.hospital_id
    when not matched then
        insert (doctor_id, name, hospital_id, zone_id, hiring_date, dismiss_date, fname, petronymic, external_id)
        values (default, new.name, 4, 2, trunc(sysdate), null, new.fname, new.petronymic, new.doctor_id);
    commit;

    dbms_output.PUT_LINE(v_arr_doctor.count);

end;

--проверка
declare
    v_out_result number;
begin
    LAZORENKO_AL.merge_and_insert_doctors(v_out_result);
end;



--создание задачи
begin

    sys.dbms_scheduler.create_job(

        job_name        => 'lazorenko_al.job_cache_doctor1',
        start_date      => to_timestamp_tz('2021/12/20 17:40:00.000000 +07:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm'),
        repeat_interval => 'FREQ=HOURLY;INTERVAL=1;',
        end_date        => null,
        job_class       => 'DEFAULT_JOB_CLASS',
        job_type        => 'PLSQL_BLOCK',

        job_action      => 'declare
                                v_out_result number;
                            begin
                                lazorenko_al.merge_and_insert_doctors(v_out_result);
                            end;',

        comments        => 'Кэширование'

    );

    sys.dbms_scheduler.set_attribute(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'RESTARTABLE',
        value     => false
    );

    sys.dbms_scheduler.set_attribute(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'RESTART_ON_RECOVERY',
        value     => false
    );

    sys.dbms_scheduler.set_attribute(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'RESTART_ON_FAILURE',
        value     => false
    );

    sys.dbms_scheduler.set_attribute_null(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'MAX_FAILURES'
    );

    sys.dbms_scheduler.set_attribute_null(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'MAX_RUNS'
    );

    sys.dbms_scheduler.set_attribute(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'LOGGING_LEVEL',
        value     => sys.dbms_scheduler.logging_full
    );

    sys.dbms_scheduler.set_attribute(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'JOB_PRIORITY',
        value     => 3
    );

    sys.dbms_scheduler.set_attribute_null(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'SCHEDULE_LIMIT'
    );

    sys.dbms_scheduler.set_attribute(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'AUTO_DROP',
        value     => false
    );

    sys.dbms_scheduler.set_attribute(
        name      => 'lazorenko_al.job_cache_doctor1',
        attribute => 'STORE_OUTPUT',
        value     => true
    );

end;
/
