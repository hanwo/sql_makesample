drop table encorezoo cascade constraint; 

CREATE table encorezoo(
	species        varchar2(20) PRIMARY KEY,
	speciesnum     NUMBER(2),
	habitat        varchar2(20),
	taste      varchar2(20),
	loc        varchar2(20)
);

insert into encorezoo values('Lion',1,'South Africa','meat','2F');
insert into encorezoo values('Tiger',5,'South Africa','meat','5F');
insert into encorezoo values('Hippo',3,'South Africa','Omnivorous','B1');
insert into encorezoo values('Elephant',6,'South Africa','Herbivore','1F');
insert into encorezoo values('Bear',2,'North America','Herbivore','1F');
insert into encorezoo values('Eagle',7,'South Africa','meat','rooftop');
insert into encorezoo values('Bold Eagle',2,'South Africa','meat','rooftop');
insert into encorezoo values('Alligator',5,'South Africa','meat','B2');


