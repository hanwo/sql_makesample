-- C : Create
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
	exception
		when dup_val_on_index then
			dbms_output.put_line('같은 종이 있습니다. 다시 입력하세요');
			insert into encorezoo values('rename', z_speciesnum, z_habitat, z_taste, z_loc);
end;
/

select * from encorezoo;
execute insert_zoo('Tiger',5,'South Africa','meat','2F');
select * from encorezoo;
delete from encorezoo where species = 'rename';

-- R : Read


create or replace procedure animal_info(z_species encorezoo.species%type)
is
	cursor zoo_cursor 
	is 
	select species,loc from encorezoo where species=z_species;
	
begin
	-- for 데이터를받을변수명선언 in 집단데이터보유한변수 loop
	-- end loop;
	for zoo_loc in zoo_cursor loop
		dbms_output.put_line(zoo_loc.species || '는 ' || zoo_loc.loc || '에 있습니다.');	
	end loop;
end;
/

exec animal_info('Eagle');



drop procedure animal_info2;
create or replace procedure animal_info2(z_loc encorezoo.loc%type)
is
	cursor zoo_cursor 
	is 
	select species,loc from encorezoo where loc=z_loc;
	
begin
	-- for 데이터를받을변수명선언 in 집단데이터보유한변수 loop
	-- end loop;
	for zoo_loc in zoo_cursor loop
		dbms_output.put_line(zoo_loc.loc || '에는 ' || zoo_loc.species || '가 있습니다.');	
	end loop;
end;
/

exec animal_info2('1F');



-- U : Update
drop procedure update_zooloc;

create or replace procedure update_zooloc(z_species encorezoo.species%type,
	z_loc encorezoo.loc%type)
is
	v_species encorezoo.species%type;
	v_loc encorezoo.loc%type;
begin   
	select species, loc
		into v_species, v_loc
	from encorezoo
	where species = v_species;
	
	if (v_species != z_species) then
		dbms_output.put_line('검색하신 동물이 없습니다.');
	else
		update encorezoo set loc=z_loc
		where v_species=z_species;
	end if;
	
	exception 
      when NO_DATA_FOUND then
      dbms_output.put_line('검색하신 동물이 없습니다');
end;
/

select species, loc from encorezoo;
execute update_zooloc('Lion1', '5F');
select species, loc from encorezoo;

drop procedure update_zooloc;


drop procedure update_zooloc;

create or replace procedure update_zooloc(
	z_species encorezoo.species%type,
	z_loc encorezoo.loc%type)
is

begin   
	update encorezoo set loc=z_loc
	where species=z_species;

	exception 
      when others then
      dbms_output.put_line('검색하신 동물이 없습니다');
end;
/













