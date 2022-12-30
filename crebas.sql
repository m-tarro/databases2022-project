/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     30.12.2022 03:02:27                          */
/*==============================================================*/
create database db_project;
use db_project;

drop table if exists author;

drop table if exists book;

drop table if exists book_author;

drop table if exists book_copy;

drop table if exists book_publisher;

drop table if exists book_subject;

drop table if exists borrow;

drop table if exists card;

drop table if exists publisher;

drop table if exists rack;

drop table if exists student;

drop table if exists subject;

/*==============================================================*/
/* Table: author                                                */
/*==============================================================*/
create table author
(
   author_id            int not null  comment '',
   author_name          text not null  comment '',
   primary key (author_id)
);

/*==============================================================*/
/* Table: book                                                  */
/*==============================================================*/
create table book
(
   ISBN                 int not null  comment '',
   title                text not null  comment '',
   language             text not null  comment '',
   number_of_pages      int not null  comment '',
   year_of_production   year not null  comment '',
   primary key (ISBN)
);

/*==============================================================*/
/* Table: book_author                                           */
/*==============================================================*/
create table book_author
(
   ISBN                 int not null  comment '',
   author_id            int not null  comment ''
);

/*==============================================================*/
/* Table: book_copy                                             */
/*==============================================================*/
create table book_copy
(
   copy_id              int not null  comment '',
   rack_id              int  comment '',
   ISBN                 int not null  comment '',
   barcode              numeric(8,0) not null  comment '',
   price                float(8,2) not null  comment '',
   purchase_date        date not null  comment '',
   primary key (copy_id)
);

/*==============================================================*/
/* Table: book_publisher                                        */
/*==============================================================*/
create table book_publisher
(
   ISBN                 int  comment '',
   publisher_id         int  comment ''
);

/*==============================================================*/
/* Table: book_subject                                          */
/*==============================================================*/
create table book_subject
(
   ISBN                 int  comment '',
   subject_id           int  comment ''
);

/*==============================================================*/
/* Table: borrow                                                */
/*==============================================================*/
create table borrow
(
   borrow_id            int not null  comment '',
   card_id              int not null  comment '',
   copy_id              int not null  comment '',
   borrow_status        bool not null  comment '',
   date_borrowed        date not null  comment '',
   date_due             date not null comment '',
   date_returned        date default NULL  comment '',
   primary key (borrow_id)
);

/*==============================================================*/
/* Table: card                                                  */
/*==============================================================*/
create table card
(
   card_id              int not null  comment '',
   student_id           int not null  comment '',
   activation_date      date not null comment '',
   card_status          bool not null  comment '',
   resource_name        text not null  comment '',
   primary key (card_id)
);

/*==============================================================*/
/* Table: publisher                                             */
/*==============================================================*/
create table publisher
(
   publisher_id         int not null  comment '',
   publisher_name       text not null  comment '',
   primary key (publisher_id)
);

/*==============================================================*/
/* Table: rack                                                  */
/*==============================================================*/
create table rack
(
   rack_id              int not null  comment '',
   rack_name            text not null  comment '',
   primary key (rack_id)
);

/*==============================================================*/
/* Table: student                                               */
/*==============================================================*/
create table student
(
   student_id           int not null  comment '',
   f_name               text not null  comment '',
   l_name               text not null  comment '',
   postal_address       text not null  comment '',
   email_address        text not null  comment '',
   phone_no             text not null  comment '',
   registered_library   bool not null  comment '',
   registered_uni       bool not null  comment '',
   primary key (student_id)
);

/*==============================================================*/
/* Table: subject                                               */
/*==============================================================*/
create table subject
(
   subject_id           int not null  comment '',
   subject_name         text not null  comment '',
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

