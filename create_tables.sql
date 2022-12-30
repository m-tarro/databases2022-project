/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     30.12.2022 03:02:27                          */
/*==============================================================*/
-- drop database if exists db_project;
-- create database db_project;
use db_project;

drop table if exists book_author;
drop table if exists book_publisher;
drop table if exists book_subject;
drop table if exists borrow;
drop table if exists book_copy;
drop table if exists author;
drop table if exists subject;
drop table if exists publisher;
drop table if exists book;
drop table if exists card;
drop table if exists rack;
drop table if exists student;

/*==============================================================*/
/* Table: author                                                */
/*==============================================================*/
create table author
(
   author_id            int not null,
   author_name          text not null,
   primary key (author_id)
);

/*==============================================================*/
/* Table: book                                                  */
/*==============================================================*/
create table book
(
   ISBN                 int not null,
   title                text not null,
   language             text not null,
   number_of_pages      int not null CHECK (number_of_pages > 0),
   year_of_production   year not null CHECK (year_of_production > 1500 AND year_of_production <= 2022),
   primary key (ISBN)
);

/*==============================================================*/
/* Table: book_author                                           */
/*==============================================================*/
create table book_author
(
   ISBN                 int not null,
   author_id            int not null
);

/*==============================================================*/
/* Table: book_copy                                             */
/*==============================================================*/
create table book_copy
(
   copy_id              int not null,
   rack_id              int,
   ISBN                 int not null,
   barcode              numeric(8,0) not null,
   price                float(8,2) not null CHECK (price >= 0),
   purchase_date        date not null,
   borrowed_status		boolean not null default false,
   primary key (copy_id)
);

/*==============================================================*/
/* Table: book_publisher                                        */
/*==============================================================*/
create table book_publisher
(
   ISBN                 int,
   publisher_id         int
);

/*==============================================================*/
/* Table: book_subject                                          */
/*==============================================================*/
create table book_subject
(
   ISBN                 int,
   subject_id           int
);

/*==============================================================*/
/* Table: borrow                                                */
/*==============================================================*/
create table borrow
(
   borrow_id            int AUTO_INCREMENT,
   card_id              int not null,
   copy_id              int not null,
   borrow_status        bool not null,
   date_borrowed        date not null,
   date_due             date not null,
   date_returned        date default NULL,
   primary key (borrow_id)
);

/*==============================================================*/
/* Table: card                                                  */
/*==============================================================*/
create table card
(
   card_id              int not null,
   student_id           int not null,
   activation_date      date not null,
   card_status          bool not null,
   resource_name        text not null,
   primary key (card_id)
);

/*==============================================================*/
/* Table: publisher                                             */
/*==============================================================*/
create table publisher
(
   publisher_id         int not null,
   publisher_name       text not null,
   primary key (publisher_id)
);

/*==============================================================*/
/* Table: rack                                                  */
/*==============================================================*/
create table rack
(
   rack_id              int not null,
   rack_name            text not null,
   primary key (rack_id)
);

/*==============================================================*/
/* Table: student                                               */
/*==============================================================*/
create table student
(
   student_id           int not null,
   f_name               text not null,
   l_name               text not null,
   postal_address       text not null,
   email_address        text not null, -- CHECK (email_address REGEXP '^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$'),
   phone_no             text not null,
   registered_library   bool not null,
   registered_uni       bool not null,
   primary key (student_id)
);

/*==============================================================*/
/* Table: subject                                               */
/*==============================================================*/
create table subject
(
   subject_id           int not null,
   subject_name         text not null,
   primary key (subject_id)
);

alter table book_author add constraint FK_BOOK_AUT_AUTHOR_NA_AUTHOR foreign key (author_id)
      references author (author_id) on delete restrict on update restrict;

alter table book_author add constraint FK_BOOK_AUT_BOOK_AUTH_BOOK foreign key (ISBN)
      references book (ISBN) on delete restrict on update restrict;

alter table book_copy add constraint FK_BOOK_COP_COPY_BELO_BOOK foreign key (ISBN)
      references book (ISBN) on delete restrict on update restrict;

alter table book_copy add constraint FK_BOOK_COP_RACK_BELO_RACK foreign key (rack_id)
      references rack (rack_id) on delete restrict on update restrict;

alter table book_publisher add constraint FK_BOOK_PUB_BOOK_PUBL_BOOK foreign key (ISBN)
      references book (ISBN) on delete restrict on update restrict;

alter table book_publisher add constraint FK_BOOK_PUB_PUBLISHER_PUBLISHE foreign key (publisher_id)
      references publisher (publisher_id) on delete restrict on update restrict;

alter table book_subject add constraint FK_BOOK_SUB_BOOK_SUBJ_BOOK foreign key (ISBN)
      references book (ISBN) on delete restrict on update restrict;

alter table book_subject add constraint FK_BOOK_SUB_SUBJECT_N_SUBJECT foreign key (subject_id)
      references subject (subject_id) on delete restrict on update restrict;

alter table borrow add constraint FK_BORROW_CARD_BORR_CARD foreign key (card_id)
      references card (card_id) on delete restrict on update restrict;

alter table borrow add constraint FK_BORROW_COPY_BORR_BOOK_COP foreign key (copy_id)
      references book_copy (copy_id) on delete restrict on update restrict;

alter table card add constraint FK_CARD_CARD_BELO_STUDENT foreign key (student_id)
      references student (student_id) on delete restrict on update restrict;