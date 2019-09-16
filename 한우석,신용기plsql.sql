[190806 팀별미션]
1. 시나리오 구성
   주제 : 동물원
   서비스 내용 : 기본 crud

   
   


drop table encorezoo cascade constraint; 


--엔코아 동물원 table 생성
CREATE table encorezoo(
	species        varchar2(20) PRIMARY KEY,
	speciesnum     NUMBER(8),
	habitat        varchar2(20),
	taste     	   varchar2(20),
	loc            varchar2(20)
);

--엔코아 동물원 동물 입주
insert into encorezoo values('Lion',1,'South Africa','Carnivore','2F');
insert into encorezoo values('Tiger',5,'South Africa','Carnivore','5F');
insert into encorezoo values('Hippo',3,'South Africa','Omnivore','B1');
insert into encorezoo values('Elephant',6,'South Africa','Herbivore','1F');
insert into encorezoo values('Bear',2,'North America','Herbivore','1F');
insert into encorezoo values('Eagle',7,'South Africa','Carnivore','rooftop');
insert into encorezoo values('Bold Eagle',2,'South Africa','Omnivore','rooftop');
insert into encorezoo values('Alligator',5,'South Africa','Carnivore','B2');

commit;

--엔코아 동물원에 새로운 가족이 찾아왔습니다. 동물원에 배치시켜 봅시다.
drop procedure insert_zoo;
create or replace procedure insert_zoo(
		z_species encorezoo.species%type,
		z_speciesnum encorezoo.speciesnum%type,
		z_habitat encorezoo.habitat%type,
		z_taste encorezoo.taste%type,
		z_loc encorezoo.loc%type)
is 	
begin
	insert into encorezoo values(z_species, z_speciesnum, z_habitat, z_taste, z_loc);
	commit;
	
	exception
		when dup_val_on_index then
			dbms_output.put_line('같은 종이 있습니다. 다시 입력하세요');
			rollback;
end;
/

select * from encorezoo;
--새로운 동물 배치시키기
execute insert_zoo('Fox', 2 ,'Northen Europe', 'Carnivore', '3B');
select * from encorezoo where species='Fox';

--동일한 동물 배치시키기 : 같은 종이 있을 때에는 확인해야 함
execute insert_zoo('Tiger', 5, 'South Africa', 'Carnivore', '2F');
select * from encorezoo;


 
--엔코아 동물원에 독수리가 있습니다. 어디에 위치해 있는지 알아봅시다. 
--*동물 위치 알아보기 : species_info 사용하기
	
create or replace procedure species_info(z_species encorezoo.species%type)
is
	cursor zoo_cursor 
	is 
	select species,loc from encorezoo where species=z_species;
	
begin
	for zoo_loc in zoo_cursor loop
		dbms_output.put_line(zoo_loc.species || '는 ' || zoo_loc.loc || '에 있습니다.');	
	end loop;
end;
/

--독수리 위치 알아보기
execute animal_info('Eagle');


--더불어, 1층에 어떠한 동물들이 있는지도 알아봅시다.
--*같은 층에 있는 동물 알아보기 : species_info2 사용하기
	
drop procedure species_info2;
create or replace procedure species_info2(z_loc encorezoo.loc%type)
is
	cursor zoo_cursor 
	is 
	select species,loc from encorezoo where loc=z_loc;
	
begin
	for zoo_loc in zoo_cursor loop
		dbms_output.put_line(zoo_loc.loc || '에는 ' || zoo_loc.species || '가 있습니다.');	
	end loop;
end;
/

--1층에 있는 동물 알아보기
execute species_info2('1F');

Lion이 동물원 내부가 답답한가봐요. 햇빛이 드는 옥상으로 자리를 옮겨줍시다.

drop procedure update_zooloc;

create or replace procedure update_zooloc(
   z_species encorezoo.species%type,
   z_loc encorezoo.loc%type)
is
   v_species encorezoo.species%type;
   v_loc encorezoo.loc%type;
begin   
   select species, loc
      into v_species, v_loc
   from encorezoo
   where species = z_species;
   
   if v_species = z_species then
      update encorezoo set loc=z_loc
      where v_species=z_species;
      dbms_output.put_line(z_species ||'를 요청하신 ' || z_loc ||'으로 옮기는데 성공했습니다');
   end if;
   
   exception
      when no_data_found then
      dbms_output.put_line('검색하신 동물은 존재하지 않습니다');
end;
/

--Lion 위치 변경하기
select species, loc from encorezoo where species='Lion';
execute update_zooloc('Lion', 'rooftop');
select species, loc from encorezoo where species='Lion';

--없는 동물 위치 변경하기
execute update_zooloc('Lion1', '2F');


--1층에 있던 곰(Bear)이 개체 보존을 위해 다른 동물원으로 가게 되었습니다.
--엔코아 동물원 명단에서 지워봅시다.

create or replace procedure del_species(
   z_species encorezoo.species%type)
is
   v_row encorezoo%rowtype;
begin
   select species
      into v_row.species
   from encorezoo
   where species = z_species;
   
   if v_row.species = z_species then
      delete encorezoo where species=z_species;
      dbms_output.put_line(z_species || '은 엔코아 동물원에 더이상 존재하지 않습니다');
   end if;
   
   exception
      when no_data_found then
      dbms_output.put_line('검색하신 동물은 존재하지 않습니다');
end;
/

--Bear 삭제하기
select species, loc from encorezoo where species = 'Bear';
execute del_species('Bear');
select * from encorezoo where species = 'Bear';

--없는 동물 삭제하기
execute del_species('Bear1');


--식성에 따라 사료를 다른걸 주어야 하니 식성에 따라 몇마리씩 있는지 알아봅시다.

drop function sum_num;
create or replace function sum_num(z_taste encorezoo.taste%type)
return number
is
	z_num encorezoo.speciesnum%type;
	cursor zoo_cursor
	is
	select species,speciesnum from encorezoo where taste=z_taste;
begin
	begin
		select sum(speciesnum)
			into z_num
		from encorezoo
		where taste = z_taste;		
	end;
	
	dbms_output.put_line('세부사항' || chr(10));
	
	begin
		for zoo_species in zoo_cursor loop
			if (z_taste = 'Carnivore') then
				dbms_output.put_line(zoo_species.species || '는 ' || zoo_species.speciesnum || '마리입니다.');
			elsif (z_taste = 'Omnivore') then
				dbms_output.put_line(zoo_species.species || '는 ' || zoo_species.speciesnum || '마리입니다.');
			elsif (z_taste = 'Herbivore') then
			dbms_output.put_line(zoo_species.species || '는 ' || zoo_species.speciesnum || '마리입니다.');
			end if;
		end loop;
	end;
	
	return z_num;
end;
/

select distinct taste, species,speciesnum from encorezoo;
select sum_num('Carnivore') 육식동물 from dual;
select sum_num('Omnivore')  잡식동물 from dual;
select sum_num('Herbivore') 초식동물 from dual;
















