
drop table lazorenko_al.error_log purge;


create table lazorenko_al.error_log(
    id_log number generated by default as identity
    (start with 1 maxvalue 9999999999999999999999999999 minvalue 1 nocycle nocache noorder) primary key,

    sh_user varchar2(50) default user,
    sh_dt date default sysdate,
    object_name varchar2(200),
    log_type varchar2(1000),
    params varchar2(4000))
    partition by range (sh_dt)
    interval (NUMTOYMINTERVAL(3, 'MONTH'))
(
    partition error_log_2021_2022_p1 values less than (to_date('22.02.2022 00:00', 'dd.mm.yyyy hh24:mi'))
);


