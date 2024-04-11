drop database if exists zeus_authz;
create database zeus_authz;
use zeus_authz;

-- 用户池
drop table if exists user_pool;
create table user_pool (
	id bigint unsigned auto_increment,
	create_time datetime not null,
    update_time datetime not null,
    name varchar(50) not null default '' comment '用户池名称',
    description varchar(255) not null default '' comment '用户池说明',
    primary key pk_id(id),
    unique key uk_name (name)
) auto_increment 100000 engine InnoDB char set utf8mb4 collate utf8mb4_bin;

-- 子应用
drop table if exists sub_app;
create table sub_app (
	id bigint unsigned auto_increment,
	create_time datetime not null,
    update_time datetime not null,
	code varchar(50) not null default 'unknown',
    name varchar(100) not null default 'unknown' comment "展示名称",
    status tinyint unsigned not null default 0 comment '子应用状态，0表示正常，1表示禁用',
    user_pool_id bigint unsigned not null default 0 comment '子应用关联到的用户池, 0表示默认的全量用户池',
    primary key pk_id(id),
    unique key uk_code(code),
    unique key uk_name (name)
) engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000 ;

-- 审计日志
-- create table audit_log (
-- 	id bigint unsigned auto_increment,
--     sub_app_id char(50) not null default 'unknown',
--     event_time bigint unsigned not null default '0' comment '事件发生时的毫秒级时间戳',
--     subject varchar(255) not null default 'unknown',
--     object varchar (255) not null default 'unknown',
--     action varchar(255) not null default 'unknown',
--     create_time datetime not null,
--     update_time datetime not null,
--     primary key pk_id(id),
--     index idx_event_time(event_time),
--     index idx_sub_app_id_event_time(sub_app_id, event_time)
-- )engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000 ;

-- 用户
drop table if exists user;
create table user (
	id bigint unsigned auto_increment,
	create_time datetime not null,
    update_time datetime not null,
	code varchar(50) not null comment '用户id',
    status tinyint unsigned not null default 0 comment '用户状态，0表示正常，1表示禁用',
    name varchar(100) not null comment '用户名称',
    avatar varchar(1024) not null default '' comment '用户头像链接',
    department varchar(1024) not null comment '用户所属部门层级，属于多个部门层级时，使用;分隔',
    primary key pk_id(id),
    unique key uk_code(code)
) engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000;

-- 用户池中的用户关联表
drop table if exists user_pool_user;
create table user_pool_user (
	id bigint unsigned auto_increment,
	create_time datetime not null,
    update_time datetime not null,
    user_pool_id bigint unsigned not null,
	user_id varchar(50) not null,
    primary key pk_id(id),
    unique key uk_user_pool_id_user_id (user_pool_id, user_id)
) engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000;

-- api caller
drop table if exists api_caller;
create table api_caller (
	id bigint unsigned auto_increment,
	create_time datetime not null,
    update_time datetime not null,
	access_key varchar(50) not null default 'unknown' comment '调用方id, 128位uuid小写十六进制编码',
    secret_key varchar(50) not null comment '调用方secret，128位uuid小写十六进制编码',
    sub_app_id varchar(50) not null comment '隶属于哪个子应用',
    status tinyint unsigned not null default 0 comment '子应用状态，0表示正常，1表示禁用',
	description varchar(255) not null,
	primary key pk_id(id),
    unique key uk_access_key(access_key),
    unique key (secret_key) comment '保证所有应用的secret都不相同，避免安全问题'
) engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000;

-- 角色定义
-- drop table if exists role;
-- create table role (
-- 	sub_app_id varchar(50) not null,
-- 	role_id varchar(50) not null default 'unknown',
--     name varchar(50) not null default 'unknown',
--     description varchar(255) not null default '',
-- 	create_time datetime not null,
--     update_time datetime not null,
--     primary key pk_sub_app_id_id(sub_app_id,id)
-- );

-- 资源类目
drop table if exists resource_category;
create table resource_category (
	id bigint unsigned auto_increment,
	create_time datetime not null,
    update_time datetime not null,
    sub_app_id varchar(50) not null default 'unknown',
    `code` varchar(50) not null default 'unknown',
    `type` tinyint unsigned default 0 comment '0表示普通资源，1表示树型资源，2表示笛卡尔积资源',
    `atrri` varchar(1024) not null default '' comment '该类型资源的附加属性值',
    name varchar(255) not null default '' comment '此类树型资源的解释性名称',
    description varchar(1024) not null,
    primary key pk_id(id),
    unique key uk_sub_app_id_code(sub_app_id, code)
) engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000;

drop table if exists flat_resource;
create table flat_resource(
	id bigint unsigned auto_increment,
	create_time datetime not null,
    update_time datetime not null,
    resource_category_id bigint unsigned default 0,
    code varchar(512) not null default '' comment '资源代码',
    name varchar(100) not null default '' comment '资源的解释性名称',
    actions varchar(1024) not null default '' comment '资源对应的操作，以逗号分隔',
    primary key pk_id(id),
    unique key uk_resource_category_id_code(resource_category_id,code)
) engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000;

-- 树型的资源，适用于页面元素等
drop table if exists tree_resource;
create table tree_resource(
	id bigint unsigned auto_increment,
	create_time datetime not null,
    update_time datetime not null,
    resource_category_id bigint unsigned default 0,
    code varchar(1024) not null default '' comment '资源代码',
    name varchar(100) not null default '' comment '资源的解释性名称',
    parent_id bigint unsigned not null default 0,
    actions varchar(1024) not null default '' comment '资源对应的操作，以逗号分隔',
    primary key pk_id(id),
	unique key uk_resource_category_id_parent_id_code(resource_category_id, parent_id, code) comment '同一个parent下不能有相同的资源'
) engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000;

-- 笛卡尔积资源
drop table if exists cartesian_product_resource;
create table cartesian_product_resource (
	id bigint unsigned auto_increment ,
	create_time datetime not null,
    update_time datetime not null,
    resource_category_id bigint unsigned default 0,
    code varchar(1024) not null default '' comment '资源代码',
    name varchar(100) not null default '' comment '资源的解释性名称',
    `set_no` tinyint unsigned comment '属于第几个集合,从0开始计算',
    actions varchar(1024) not null default '' comment '资源对应的操作，以逗号分隔',
    primary key pk_id(id),
    unique key uk_set_no_code(set_no, code) comment '同一个集合中的资源代码不能相同'
) engine InnoDB char set utf8mb4 collate utf8mb4_bin auto_increment 100000;